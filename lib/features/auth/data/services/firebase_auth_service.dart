import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/auth_user.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // GET USER
  User? getUser() {
    return firebaseAuth.currentUser;
  }

  // SIGN IN EMAIL
  Future<AuthUser?> signIn(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) return null;

      return AuthUser(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        imageUrl: user.photoURL ?? '',
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // SIGN UP EMAIL
  Future<void> signUp(String email, String password, String name) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // GOOGLE SIGN IN
  Future<AuthUser?> signInWithGoogle() async {
    try {
      UserCredential credential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        credential = await firebaseAuth.signInWithPopup(googleProvider);
      } else {
        final googleUser = await googleSignIn.signIn();

        if (googleUser == null) return null;

        final googleAuth = await googleUser.authentication;

        final authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        credential = await firebaseAuth.signInWithCredential(authCredential);
      }

      final user = credential.user;

      if (user == null) return null;

      return AuthUser(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        imageUrl: user.photoURL ?? '',
      );
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      throw Exception("Failed to logOut : $e");
    }
  }
}
