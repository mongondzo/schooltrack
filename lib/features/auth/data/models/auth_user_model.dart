// RÔLE : Version "Data" de l'entité AuthUserEntity.
// Sait se convertir depuis/vers Firestore ET depuis
// un compte Firebase Auth (User).
//
// Diagram :
//   Firebase Auth User  ──→  AuthUserModel  ──→  AuthUserEntity
//   Firestore Map       ──→  AuthUserModel  ──→  AuthUserEntity

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  // Le constructeur appelle directement le constructeur parent
  const AuthUserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.photoUrl,
    required super.role,
    required super.schoolId,
    required super.createdAt,
  });

  // Utilisé quand on récupère le profil d'un utilisateur
  // déjà existant depuis users/{uid}.
  //
  // Exemple :
  //   final doc = await firestore.collection('users').doc(uid).get();
  //   final user = AuthUserModel.fromFirestore(doc);
  factory AuthUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AuthUserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      role: data['role'] ?? 'admin',
      schoolId: data['schoolId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ──────────────────────────────────────────────────────────
  // fromFirebaseUser() — Compte Google → AuthUserModel
  //
  // Utilisé lors de la PREMIÈRE connexion, quand l'utilisateur
  // n'existe pas encore dans Firestore. On prend les infos
  // directement depuis son compte Google via Firebase Auth.
  //
  // Paramètre role : 'admin' par défaut pour SchoolTrack.
  // ──────────────────────────────────────────────────────────
  factory AuthUserModel.fromFirebaseUser(
    User firebaseUser, {
    String role = 'admin',
    String schoolId = '',
  }) {
    return AuthUserModel(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'Utilisateur',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      role: role,
      schoolId: schoolId,
      // Première connexion → maintenant
      createdAt: DateTime.now(),
    );
  }

  // toMap() — AuthUserModel → Map pour Firestore
  //
  // Utilisé pour créer ou mettre à jour le document
  // users/{uid} dans Firestore.
  Map<String, dynamic> toMap() {
    return {
      // On inclut uid dans les champs pour faciliter les
      // requêtes Firestore (chercher par uid sans connaître
      // le chemin du document)
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
      'schoolId': schoolId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // fromMap() — Map brute → AuthUserModel
  //
  // Utile si vous avez déjà les données sous forme de Map
  // sans avoir le DocumentSnapshot de Firestore.
  factory AuthUserModel.fromMap(Map<String, dynamic> map, String id) {
    return AuthUserModel(
      uid: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      role: map['role'] ?? 'admin',
      schoolId: map['schoolId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
