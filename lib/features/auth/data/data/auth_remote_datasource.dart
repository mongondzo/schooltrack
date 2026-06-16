import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schooltrack/features/auth/data/models/user_model.dart';

// Interface de la source de données distante
abstract class AuthRemoteDatasource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

// Implémentation concrète avec Firebase et Google Sign In
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  // Instance Firebase Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Instance Google Sign In
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Instance Firestore pour sauvegarder les données utilisateur
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> signInWithGoogle() async {
    // Étape 1 : Ouvre la fenêtre de sélection de compte Google
    final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();

    if (googleAccount == null) {
      // L'utilisateur a annulé la connexion
      throw Exception('Connexion annulée par l\'utilisateur');
    }

    // Étape 2 : Récupère les tokens d'authentification Google
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;

    // Étape 3 : Crée les credentials Firebase depuis les tokens Google
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Étape 4 : Connecte l'utilisateur dans Firebase Auth
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final User firebaseUser = userCredential.user!;

    // Étape 5 : Crée le modèle utilisateur
    final UserModel userModel = UserModel.fromFirebaseUser(firebaseUser);

    // Étape 6 : Sauvegarde ou met à jour l'utilisateur dans Firestore
    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(userModel.toMap(), SetOptions(merge: true));
    // merge: true = on ne remplace pas les champs existants

    return userModel;
  }

  @override
  Future<void> signOut() async {
    // Déconnecte des deux services
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // Récupère l'utilisateur Firebase actuellement connecté
    final User? firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) return null;

    // Essaie de récupérer les données depuis Firestore
    final doc = await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }

    // Sinon, crée depuis Firebase Auth
    return UserModel.fromFirebaseUser(firebaseUser);
  }
}
