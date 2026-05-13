import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Layanan Autentikasi Tingkat Enterprise.
/// Mengintegrasikan Supabase Auth dan Google OAuth.
/// Sesuai Standar SDA V2: Fokus pada Social Auth & Email.
class AuthService extends GetxService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  // Web Client ID (Wajib untuk handshake Google <-> Supabase)
  final String _webClientId = '353922058441-j4voev2ai15av984u7sgmd4ba78248b3.apps.googleusercontent.com';
  
  // Android Client ID (Untuk stabilitas di perangkat Android)
  final String _androidClientId = '353922058441-ljqqf9nh8rtnsjnqvl1k5oqbntsf6l5j.apps.googleusercontent.com';

  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    _listenToAuthState();
  }

  void _listenToAuthState() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      currentUser.value = user;
      isLoggedIn.value = user != null;
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        await _secureStorage.write(key: 'saved_email', value: email);
        _logger.i('Autentikasi Berhasil: ${response.user!.email}');
      }
    } catch (e) {
      _logger.e('Kesalahan Autentikasi: $e');
      rethrow;
    }
  }

  /// Registrasi akun baru menggunakan kredensial email dan nama.
  Future<void> signUp(String email, String password, {String? name}) async {
    try {
      await _supabase.auth.signUp(
        email: email, 
        password: password,
        data: name != null ? {'full_name': name} : null,
      );
      _logger.i('Registrasi Berhasil untuk: $email');
    } catch (e) {
      _logger.e('Kesalahan Registrasi: $e');
      rethrow;
    }
  }

  /// NATIVE GOOGLE SIGN IN (Handshake Web & Android)
  Future<void> nativeGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: _webClientId,
        clientId: _androidClientId,
      );
      
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) throw 'Gagal memperoleh ID Token dari Google.';

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      
      _logger.i('Google Login Berhasil: ${googleUser.email}');
    } catch (e) {
      _logger.e('Kesalahan Google Auth: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _logger.i('Sesi Berakhir: User Logged Out');
  }

  String? get currentUserId => _supabase.auth.currentUser?.id;
}
