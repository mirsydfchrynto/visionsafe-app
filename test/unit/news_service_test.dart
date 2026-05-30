import 'package:flutter_test/flutter_test.dart';
import 'package:visionsafe/app/data/services/rss_parser.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';

void main() {
  group('RssParser Curation & Safety Tests', () {
    test('Harus mem-parsing feed RSS valid dan mencocokkan topik relevan', () {
      const xml = '''
      <rss version="2.0">
        <channel>
          <item>
            <title>Pentingnya Jarak Layar dan Miopi pada Anak</title>
            <link>https://health.harvard.edu/blog/myopia-child-screen?utm_source=rss&amp;utm_medium=feed</link>
            <pubDate>2026-05-20T12:00:00Z</pubDate>
            <description><![CDATA[<p>Menjaga jarak mata minimal 30cm dapat secara signifikan mengurangi risiko rabun dekat atau miopi.</p>]]></description>
            <category>Eye Health</category>
          </item>
        </channel>
      </rss>
      ''';

      final results = RssParser.parse(xml, 'Harvard Health');
      expect(results.length, 1);
      
      final article = results.first;
      expect(article.title, 'Pentingnya Jarak Layar dan Miopi pada Anak');
      // Verify HTML is sanitized
      expect(article.description, isNot(contains('<p>')));
      // Verify UTM params are stripped
      expect(article.url, 'https://health.harvard.edu/blog/myopia-child-screen');
      expect(article.sourceName, 'Harvard Health');
    });

    test('Harus mengabaikan artikel yang tidak relevan dengan ekosistem', () {
      const xml = '''
      <rss version="2.0">
        <channel>
          <item>
            <title>Penyakit Jantung dan Kesehatan Kolesterol</title>
            <link>https://health.harvard.edu/blog/heart-disease</link>
            <description>Tips makan sayur untuk menurunkan kolesterol jahat Anda.</description>
          </item>
        </channel>
      </rss>
      ''';

      final results = RssParser.parse(xml, 'Harvard Health');
      expect(results.isEmpty, true);
    });

    test('Harus mengabaikan artikel dengan kata kunci terlarang (Keamanan Konten)', () {
      const xml = '''
      <rss version="2.0">
        <channel>
          <item>
            <title>Bagaimana Kebijakan Politik Memengaruhi Anggaran Kesehatan Mata</title>
            <link>https://health.harvard.edu/blog/politics-eye-health</link>
            <description>Analisis pemilu presiden dan kebijakan asuransi mata nasional.</description>
          </item>
        </channel>
      </rss>
      ''';

      final results = RssParser.parse(xml, 'Harvard Health');
      expect(results.isEmpty, true);
    });

    test('Harus memetakan emosi Vizo secara dinamis berdasarkan konten berita', () {
      const xml = '''
      <rss version="2.0">
        <channel>
          <item>
            <title>Bahaya Radiasi Cahaya Biru (Blue Light) dan Mata Lelah</title>
            <link>https://health.harvard.edu/blog/blue-light-strain</link>
            <description>Mata lelah akibat menatap gawai terlalu lama di malam hari.</description>
          </item>
        </channel>
      </rss>
      ''';

      final results = RssParser.parse(xml, 'Harvard Health');
      expect(results.length, 1);
      expect(results.first.mascotState, VizoState.worried);
    });
  });
}
