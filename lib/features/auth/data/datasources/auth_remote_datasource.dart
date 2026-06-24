// ===========================================================
// FICHIER : auth_remote_datasource.dart
// CHEMIN  : features/auth/data/datasources/auth_remote_datasource.dart
//
// RÔLE : Seul fichier qui parle directement à Firebase Auth,
// Google Sign-In et Cloud Firestore pour l'authentification.
//
// Responsabilités :
//   1. Connexion Google (via Firebase Auth + Google Sign-In)
//   2. Lecture/écriture du profil utilisateur dans Firestore
//   3. Déconnexion
//   4. Vérification de la session active
// ===========================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth_user_model.dart';

class AuthRemoteDataSource {
  // ── Services Firebase ─────────────────────────────────────
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  // ── Collection Firestore des utilisateurs ─────────────────
  static const String _usersCollection = 'users';

  // ── Constructeur avec valeurs par défaut ──────────────────
  // En passant les dépendances en paramètre, c'est plus facile
  // à tester et à configurer. Mais par défaut on utilise les
  // instances globales Firebase.
  AuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // ──────────────────────────────────────────────────────────
  // signInWithGoogle() — Connexion complète avec Google
  //
  // Étapes :
  //   1. Ouvre le sélecteur de compte Google
  //   2. Obtient les tokens Google
  //   3. Connecte via Firebase Auth
  //   4. Vérifie si le profil existe déjà dans Firestore
  //   5. Si non → crée le profil (première connexion)
  //   6. Si oui → récupère le profil existant
  //   7. Retourne l'utilisateur prêt à l'emploi
  // ──────────────────────────────────────────────────────────
  Future<AuthUserModel> signInWithGoogle() async {
    // ── Étape 1 : Ouvre le sélecteur de compte Google ───────
    final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();

    // L'utilisateur a annulé la sélection de compte
    if (googleAccount == null) {
      throw Exception('Connexion annulée par l\'utilisateur');
    }

    // ── Étape 2 : Récupère les tokens d'authentification ────
    // Ces tokens prouvent à Firebase que Google a validé l'identité
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;

    // ── Étape 3 : Crée un credential Firebase à partir des tokens
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // ── Étape 4 : Connecte l'utilisateur dans Firebase Auth ─
    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    final User? firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Erreur Firebase : utilisateur null après connexion');
    }

    // ── Étape 5 : Vérifie si le profil existe dans Firestore ─
    // Chaque utilisateur a son propre document : users/{uid}
    final existingUser = await _getUserFromFirestore(firebaseUser.uid);

    if (existingUser != null) {
      // L'utilisateur s'est déjà connecté auparavant
      // On retourne son profil existant (avec son rôle, schoolId, etc.)
      return existingUser;
    }

    // ── Étape 6 : Première connexion → création du profil ───
    // On crée un profil "admin" par défaut pour SchoolTrack.
    // Vous pouvez changer ce comportement selon votre logique
    // (ex: un admin valide manuellement le rôle d'un nouveau compte)
    final newUser = AuthUserModel.fromFirebaseUser(
      firebaseUser,
      role: 'admin', // Rôle par défaut à la première connexion
      schoolId: '',  // À remplir plus tard dans les paramètres
    );

    // ── Étape 7 : Sauvegarde le profil dans Firestore ───────
    await _createUserInFirestore(newUser);

    return newUser;
  }

  // ──────────────────────────────────────────────────────────
  // getCurrentUser() — Récupère l'utilisateur actuellement connecté
  //
  // Appelé au démarrage de l'app (CheckAuthStatus).
  // Firebase conserve la session localement même si l'app est
  // fermée. Cette méthode vérifie si cette session est encore
  // valide et retourne le profil Firestore correspondant.
  //
  // Retourne null si personne n'est connecté.
  // ──────────────────────────────────────────────────────────
  Future<AuthUserModel?> getCurrentUser() async {
    // Vérifie la session Firebase en cours
    final User? firebaseUser = _firebaseAuth.currentUser;

    // Personne n'est connecté
    if (firebaseUser == null) return null;

    // Quelqu'un est connecté → on récupère son profil Firestore
    // (pour avoir le rôle, schoolId, etc. qui ne sont pas dans Firebase Auth)
    return await _getUserFromFirestore(firebaseUser.uid);
  }

  // ──────────────────────────────────────────────────────────
  // signOut() — Déconnexion complète
  //
  // Il faut déconnecter des DEUX services :
  //   - Firebase Auth (session Firebase)
  //   - Google Sign-In (pour que le sélecteur de compte
  //     réapparaisse à la prochaine connexion)
  // ──────────────────────────────────────────────────────────
  Future<void> signOut() async {
    // Ordre important : Google d'abord, Firebase ensuite
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  // ──────────────────────────────────────────────────────────
  // authStateChanges — Stream de l'état de connexion
  //
  // Firebase émet automatiquement dans ce Stream quand :
  //   - Un utilisateur se connecte → émet User
  //   - Un utilisateur se déconnecte → émet null
  //   - La session expire → émet null
  //
  // On le mappe pour retourner un AuthUserModel (profil complet)
  // plutôt que le User Firebase basique.
  // ──────────────────────────────────────────────────────────
  Stream<AuthUserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      // Pas de session → on retourne null
      if (firebaseUser == null) return null;

      // Session active → on récupère le profil complet dans Firestore
      return await _getUserFromFirestore(firebaseUser.uid);
    });
  }

  // ══════════════════════════════════════════════════════════
  // MÉTHODES PRIVÉES — Interactions Firestore
  // Ces méthodes sont "privées" (préfixe _) car elles sont
  // des détails d'implémentation. Seule cette classe les utilise.
  // ══════════════════════════════════════════════════════════

  // ── Lecture : récupère un profil utilisateur ─────────────
  // Retourne null si le document n'existe pas encore
  Future<AuthUserModel?> _getUserFromFirestore(String uid) async {
    final doc =
        await _firestore.collection(_usersCollection).doc(uid).get();

    // .exists vérifie que le document a bien été trouvé
    if (!doc.exists || doc.data() == null) return null;

    return AuthUserModel.fromFirestore(doc);
  }

  // ── Écriture : crée le profil d'un nouvel utilisateur ────
  // Utilise .set() avec merge: false pour créer le document.
  // Si le document existait déjà, il sera écrasé.
  // (Cas normalement impossible car on vérifie avant d'appeler)
  Future<void> _createUserInFirestore(AuthUserModel user) async {
    await _firestore
        .collection(_usersCollection)
        .doc(user.uid) // L'uid devient le nom du document
        .set(user.toMap());

    // ── Structure Firestore créée ──────────────────────────
    //
    // users/
    //   {uid}/
    //     uid: "abc123"
    //     name: "Marie Curie"
    //     email: "marie@gmail.com"
    //     photoUrl: "https://..."
    //     role: "admin"
    //     schoolId: ""
    //     createdAt: Timestamp(...)
    //
    // ── Comment isoler les données des autres collections ──
    //
    // Quand vous ajoutez un élève, une classe, etc., ajoutez
    // le champ "ownerId" avec la valeur user.uid :
    //
    //   await firestore.collection('students').add({
    //     'ownerId': user.uid,   // ← CLEF DE L'ISOLATION
    //     'nom': 'Dupont',
    //     ...
    //   });
    //
    // Quand vous lisez les élèves, filtrez par ownerId :
    //
    //   firestore
    //     .collection('students')
    //     .where('ownerId', isEqualTo: user.uid)  // ← FILTRE
    //     .snapshots()
    //
    // Ainsi chaque admin voit UNIQUEMENT ses propres élèves.
  }

  // ── Mise à jour : modifie certains champs du profil ──────
  // Utile pour mettre à jour le schoolId, le rôle, etc.
  Future<void> updateUserInFirestore(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(_usersCollection).doc(uid).update(data);
  }
}
