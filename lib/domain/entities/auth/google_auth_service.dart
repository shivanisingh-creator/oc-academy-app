import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);
  final Logger _logger = Logger();
  Future<String?> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      return googleAuth.accessToken;
    } catch (e) {
      _logger.e('Google Sign-In Error', error: e);
      return null;
    }
  }
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      _logger.e('Google Sign-Out Error', error: e);
    }
  }
}
