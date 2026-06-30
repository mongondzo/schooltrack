// ════════════════════════════════════════════════════════════════
// DATASOURCE : ProfileRemoteDataSource
// Couche     : Data
// Rôle       : Seul endroit du projet qui parle à Firebase
//              pour les profils. Firestore + Auth + Google Sign-In.
//              Si tu changes de backend → tu modifies seulement ici.
// ════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schooltrack/features/profile/data/models/profile_model.dart';

// ── Interface ─────────────────────────────────────────────────
abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String uid);
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
  });
  Future<void> logout();
}

// ── Implémentation Firebase ───────────────────────────────────
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── Lire le profil depuis Firestore ──────────────────────────
  @override
  Future<ProfileModel> getProfile(String uid) async {
    // On cherche le document dans la collection "users" avec l'UID
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      // Si le document n'existe pas encore (1ère connexion),
      // on crée un profil de base depuis Firebase Auth
      final user = _auth.currentUser!;
      final defaultProfile = ProfileModel(
        id: user.uid,
        name: user.displayName ?? 'Utilisateur',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        role: 'admin',
        phone: '',
        createdAt: DateTime.now(),
      );
      // On le sauvegarde dans Firestore pour la prochaine fois
      await _firestore
          .collection('users')
          .doc(uid)
          .set(defaultProfile.toMap());
      return defaultProfile;
    }

    return ProfileModel.fromMap(uid, doc.data()!);
  }

  // ── Mettre à jour le profil dans Firestore ───────────────────
  @override
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
  }) async {
    // .update() ne modifie QUE les champs fournis
    // Les autres champs (email, role, photoUrl…) ne bougent pas
    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'phone': phone,
    });
  }

  // ── Déconnexion complète ──────────────────────────────────────
  @override
  Future<void> logout() async {
    // On déconnecte les deux services en parallèle pour aller plus vite
    await Future.wait([
      _auth.signOut(),          // Déconnecte Firebase Auth
      _googleSignIn.signOut(),  // Déconnecte le compte Google
    ]);
  }
}
