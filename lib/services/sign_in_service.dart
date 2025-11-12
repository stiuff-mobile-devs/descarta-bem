import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInService {
  final auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  SignInService();

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      return googleUser != null
          ? await _signIn(googleUser)
          : false;
    } catch (e) {
      debugPrint("Error on sign in with google: $e");
      return false;
    }
  }

  Future<bool> _signIn(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
      debugPrint("Usuário logado");
      return true;
    } catch (e) {
      debugPrint("ERRO ao logar: $e");
      return false;
    }
  }

  signOut() async {
    try {
      await auth.signOut();
      googleSignIn.disconnect();
      debugPrint('Deslogado');
    } catch (e) {
      debugPrint("ERRO deslogando:\n$e");
    }
  }

  User? getFirebaseAuthUser() {
    return auth.currentUser;
  }

  bool isLoggedIn() {
    return getFirebaseAuthUser() != null;
  }
}
