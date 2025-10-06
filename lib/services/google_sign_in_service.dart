import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Use the singleton
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        clientId: "3",
        serverClientId:
            '86965198007-fq4satrcnlll7io79h2g2tfrnjnqdop4.apps.googleusercontent.com',
      );
      _isInitialized = true;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _ensureInitialized();

      // interactive sign-in
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      // get authorization / access tokens (separate step)
      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleUser.authentication.idToken,
      );

      return await auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      Helpers.print('Google Sign-In error: ${e.code.name} - ${e.description}');
      return null;
    } catch (e) {
      Helpers.print('Unexpected error during Google Sign-In: $e');
      return null;
    }
  }

  Future<UserCredential?> signInSilently() async {
    try {
      await _ensureInitialized();

      final result = _googleSignIn.attemptLightweightAuthentication();

      GoogleSignInAccount? googleUser;
      if (result is Future<GoogleSignInAccount?>) {
        googleUser = await result;
      } else {
        googleUser = result as GoogleSignInAccount?;
      }

      if (googleUser == null) return null;

      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleUser.authentication.idToken,
      );

      return await auth.signInWithCredential(credential);
    } catch (e) {
      Helpers.print('Silent sign-in failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await auth.signOut();
  }

  Future<void> disconnect() async {
    await _googleSignIn.disconnect();
    await auth.signOut();
  }
}
