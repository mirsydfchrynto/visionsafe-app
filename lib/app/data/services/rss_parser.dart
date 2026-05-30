import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:visionsafe/app/data/models/news_model.dart';

class RssParser {
  static final RegExp _itemRegex = RegExp(r'<item>([\s\S]*?)<\/item>');
  static final RegExp _entryRegex = RegExp(r'<entry>([\s\S]*?)<\/entry>');

  static final RegExp _titleRegex = RegExp(r'<title[^>]*>(?:<!\[CDATA\[)?([\s\S]*?)(?:\]\]>)?<\/title>');
  static final RegExp _linkRegex = RegExp(r'<link[^>]*>(?:<!\[CDATA\[)?([\s\S]*?)(?:\]\]>)?<\/link>');
  static final RegExp _linkHrefRegex = RegExp('<link\\s+[^>]*href=["\']([^"\']+)["\']');
  static final RegExp _descRegex = RegExp(r'<(?:description|summary|content:encoded)[^>]*>(?:<!\[CDATA\[)?([\s\S]*?)(?:\]\]>)?<\/(?:description|summary|content:encoded)>');
  static final RegExp _pubDateRegex = RegExp(r'<(?:pubDate|published|updated)>([\s\S]*?)<\/(?:pubDate|published|updated)>');
  static final RegExp _categoryRegex = RegExp(r'<category[^>]*>(?:<!\[CDATA\[)?([\s\S]*?)(?:\]\]>)?<\/category>');

  static const List<String> _trustedDomains = [
    'who.int', 'mayoclinic.org', 'clevelandclinic.org', 'nih.gov', 'pubmed',
    'healthline.com', 'medicalnewstoday.com', 'harvard.edu', 'cdc.gov', 'sciencedaily.com'
  ];

  static const List<String> _positiveKeywords = [
    'eye', 'mata', 'myopia', 'miopi', 'rabun', 'screen', 'layar', 'gadget', 'gawai',
    'posture', 'postur', 'blue light', 'cahaya biru', 'vision', 'penglihatan', 'kacamata',
    'glasses', 'wellness', 'sleep', 'tidur', 'ergonomic', 'ergonomi', 'dry eye', 'eye strain',
    'screen time', 'focus', 'fokus', 'smart device', 'pediatric screen safety', 'child gadget safety',
    'gadget addiction', 'screen addiction', 'healthy posture', 'focus habits', 'vision care',
    'educational health', 'pediatric screen', 'ai healthcare', 'computer vision', 'mobile health',
    'productivity wellness', 'sleep health', 'kecanduan layar', 'kesehatan mata', 'sensor jarak'
  ];

  static const List<String> _negativeKeywords = [
    'politics', 'politik', 'election', 'pemilu', 'presiden', 'pilkada', 'crypto', 'kripto', 'bitcoin',
    'sports', 'olahraga', 'football', 'soccer', 'war', 'perang', 'military', 'nsfw', 'casino', 'gambling',
    'stock price', 'market index', 'investment', 'you won\'t believe', 'shocking truth', 'this one simple trick',
    'doctors are furious', 'will blow your mind', 'secret method', 'hidden secret', 'miracle cure'
  ];

  static List<NewsModel> parse(String xmlContent, String sourceName) {
    final List<NewsModel> articles = [];
    final hasItems = xmlContent.contains('<item>');
    final matches = hasItems ? _itemRegex.allMatches(xmlContent) : _entryRegex.allMatches(xmlContent);

    for (final match in matches) {
      final block = match.group(1) ?? '';
      final rawTitle = _extractTag(block, _titleRegex);
      final rawLink = hasItems ? _extractTag(block, _linkRegex) : _extractLinkHref(block);
      final rawDesc = _extractTag(block, _descRegex);
      final rawDate = _extractTag(block, _pubDateRegex);
      final rawCategory = _extractTag(block, _categoryRegex);

      if (rawTitle.isEmpty || rawLink.isEmpty) continue;

      final title = _sanitizeText(rawTitle);
      final url = _cleanUrl(_sanitizeText(rawLink));

      // 1. Domain & Protocol Validation
      if (!url.startsWith('http://') && !url.startsWith('https://')) continue;
      if (!_isTrustedDomain(url)) continue;

      // 2. Topic & Clickbait Filter Pipeline
      if (title.length < 10) continue;
      final description = _cleanSummary(rawDesc);
      if (description.isEmpty || description.length < 15) continue;
      
      if (!_isTopicRelevant(title, description)) continue;
      if (_containsForbiddenContent(title, description)) continue;

      final publishedAt = _parseDate(rawDate);
      if (publishedAt.isAfter(DateTime.now())) continue;

      final id = sha256.convert(utf8.encode(url)).toString().substring(0, 16);

      articles.add(NewsModel(
        id: id,
        title: title,
        description: description,
        category: _mapCategory(rawCategory, "$title $description"),
        url: url,
        publishedAt: publishedAt,
        sourceName: sourceName,
      ));
    }

    return articles;
  }

  static String _extractTag(String block, RegExp regex) {
    final match = regex.firstMatch(block);
    return match?.group(1)?.trim() ?? '';
  }

  static String _extractLinkHref(String block) {
    final match = _linkHrefRegex.firstMatch(block);
    return match?.group(1)?.trim() ?? '';
  }

  static String _sanitizeText(String text) {
    var clean = text.replaceAll(RegExp(r'<[^>]*>'), '');
    final entities = {
      '&amp;': '&', '&lt;': '<', '&gt;': '>', '&quot;': '"', '&#39;': "'",
      '&rsquo;': "'", '&lsquo;': "'", '&ldquo;': '"', '&rdquo;': '"',
      '&ndash;': '-', '&mdash;': '-', '&nbsp;': ' '
    };
    entities.forEach((key, value) {
      clean = clean.replaceAll(key, value);
    });
    clean = clean.replaceAll(RegExp(r'Share on Facebook.*$', caseSensitive: false), '');
    clean = clean.replaceAll(RegExp(r'Read more.*$', caseSensitive: false), '');
    return clean.trim();
  }

  static String _cleanUrl(String url) {
    try {
      final uri = Uri.parse(url.trim());
      final cleanQueryParams = Map<String, String>.from(uri.queryParameters)
        ..removeWhere((key, value) => key.startsWith('utm_') || key == 'feed' || key == 'rss');
      final cleanUrlStr = uri.replace(queryParameters: cleanQueryParams).toString();
      return cleanUrlStr.endsWith('?') ? cleanUrlStr.substring(0, cleanUrlStr.length - 1) : cleanUrlStr;
    } catch (_) {
      return url.trim();
    }
  }

  static bool _isTrustedDomain(String url) {
    try {
      final host = Uri.parse(url).host.toLowerCase();
      return _trustedDomains.any((domain) => host.contains(domain));
    } catch (_) {
      return false;
    }
  }

  static bool _isTopicRelevant(String title, String description) {
    final searchArea = '$title $description'.toLowerCase();
    return _positiveKeywords.any((keyword) => searchArea.contains(keyword));
  }

  static bool _containsForbiddenContent(String title, String description) {
    final searchArea = '$title $description'.toLowerCase();
    return _negativeKeywords.any((keyword) => searchArea.contains(keyword));
  }

  static DateTime _parseDate(String dateStr) {
    if (dateStr.isEmpty) return DateTime.now();
    try {
      return DateTime.tryParse(dateStr) ?? DateTime.now();
    } catch (_) {
      return DateTime.now();
    }
  }

  static String _cleanSummary(String rawDesc) {
    var clean = _sanitizeText(rawDesc);
    if (clean.length > 160) {
      final truncated = clean.substring(0, 160);
      final lastSentenceEnd = RegExp(r'[.!?]\s').allMatches(truncated);
      if (lastSentenceEnd.isNotEmpty) {
        clean = truncated.substring(0, lastSentenceEnd.last.end).trim();
      } else {
        final lastSpace = truncated.lastIndexOf(' ');
        clean = lastSpace > 100 ? "${truncated.substring(0, lastSpace).trim()}..." : "${truncated.trim()}...";
      }
    }
    
    // Emotional Curation - softening sensational vocabulary into calming, educational tones
    final Map<String, String> emotionalSoftener = {
      'shocking': 'penting', 'danger': 'perhatian', 'deadly': 'serius', 'horrible': 'kurang sehat',
      'scary': 'menantang', 'worst': 'kurang optimal', 'destroy': 'mempengaruhi', 'killing': 'mengancam'
    };
    emotionalSoftener.forEach((key, val) {
      clean = clean.replaceAll(RegExp(r'\b' + key + r'\b', caseSensitive: false), val);
    });
    return clean;
  }

  static String _mapCategory(String rawCat, String text) {
    if (rawCat.isNotEmpty) {
      final cleanCat = _sanitizeText(rawCat).toLowerCase();
      if (cleanCat.contains("eye") || cleanCat.contains("vision") || cleanCat.contains("mata")) return "Mata";
      if (cleanCat.contains("posture") || cleanCat.contains("ergonomic") || cleanCat.contains("postur")) return "Postur";
      if (cleanCat.contains("sleep") || cleanCat.contains("tidur") || cleanCat.contains("night")) return "Tidur";
      if (cleanCat.contains("screen") || cleanCat.contains("device") || cleanCat.contains("layar")) return "Layar";
    }
    final lowerText = text.toLowerCase();
    if (lowerText.contains("posture") || lowerText.contains("postur") || lowerText.contains("duduk")) return "Postur";
    if (lowerText.contains("sleep") || lowerText.contains("tidur") || lowerText.contains("insomnia")) return "Tidur";
    if (lowerText.contains("screen") || lowerText.contains("layar") || lowerText.contains("gadget")) return "Layar";
    if (lowerText.contains("eye") || lowerText.contains("mata") || lowerText.contains("myopia")) return "Mata";
    return "Edukasi";
  }
}
