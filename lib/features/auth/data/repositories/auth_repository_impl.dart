// ===========================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schooltrack/features/auth/domain/entities/auth_user_entity.dart';
import 'package:schooltrack/features/auth/data/models/auth_user_model.dart';

// ──────────────────────────────────────────────────────────
// Contrat (interface)
// ──────────────────────────────────────────────────────────
abstract class AuthRepository {
  Future<AuthUserEntity> signInWithGoogle();
  Future<AuthUserEntity?> getCurrentUser();
  Future<void> signOut();
}

// ──────────────────────────────────────────────────────────
// Implémentation concrète
// ──────────────────────────────────────────────────────────
class AuthRepositoryImpl implements AuthRepository {
  // Services Firebase
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  // Collection Firestore des utilisateurs
  static const String _usersCollection = 'users';

  // Constructeur
  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  // ──────────────────────────────────────────────────────────
  // Connexion avec Google
  // ──────────────────────────────────────────────────────────
  @override
  Future<AuthUserEntity> signInWithGoogle() async {
    // Étape 1 : Ouvrir le sélecteur de compte Google
    final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();

    // L'utilisateur a annulé
    if (googleAccount == null) {
      throw Exception('Connexion annulée par l\'utilisateur');
    }

    // Étape 2 : Récupérer les tokens
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;

    // Étape 3 : Créer un credential Firebase
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Étape 4 : Connecter avec Firebase
    final UserCredential userCredential = await _firebaseAuth
        .signInWithCredential(credential);

    final User? firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Erreur : utilisateur introuvable');
    }

    // Étape 5 : Créer l'objet AuthUserModel depuis Firebase
    final userModel = AuthUserModel.fromFirebaseUser(firebaseUser);

    // Étape 6 : Sauvegarder dans Firestore
    await _saveUserToFirestore(userModel);

    return userModel;
  }

  // ──────────────────────────────────────────────────────────
  // Vérifie si quelqu'un est connecté
  // ──────────────────────────────────────────────────────────
  @override
  Future<AuthUserEntity?> getCurrentUser() async {
    // Vérifie la session Firebase
    final User? firebaseUser = _firebaseAuth.currentUser;

    // Personne n'est connecté
    if (firebaseUser == null) return null;

    // Récupère les infos depuis Firestore
    return await _getUserFromFirestore(firebaseUser.uid);
  }

  // ──────────────────────────────────────────────────────────
  // Déconnexion
  // ──────────────────────────────────────────────────────────
  @override
  Future<void> signOut() async {
    // Déconnecter de Google
    await _googleSignIn.signOut();
    // Déconnecter de Firebase
    await _firebaseAuth.signOut();
  }

  // ──────────────────────────────────────────────────────────
  // Méthodes privées (pour Firestore)
  // ──────────────────────────────────────────────────────────

  // Sauvegarde l'utilisateur dans Firestore
  Future<void> _saveUserToFirestore(AuthUserModel user) async {
    await _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .set(user.toMap());
  }

  // Récupère un utilisateur depuis Firestore
  Future<AuthUserEntity?> _getUserFromFirestore(String uid) async {
    final doc = await _firestore.collection(_usersCollection).doc(uid).get();

    if (!doc.exists || doc.data() == null) return null;

    return AuthUserModel.fromFirestore(doc);
  }
}
