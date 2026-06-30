// ════════════════════════════════════════════════════════════════
// MODÈLE : ProfileModel
// Couche  : Data
// Rôle    : Étend ProfileEntity et sait lire/écrire Firestore.
//           C'est la seule classe qui connaît le format de stockage.
//
//  ProfileEntity (domain)  ←── ProfileModel (data) ←── Firestore
// ════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schooltrack/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
    required super.role,
    required super.phone,
    required super.createdAt,
  });

  // ── Depuis un Map Firestore ───────────────────────────────────
  // Utilisé après doc.data() qui retourne un Map<String, dynamic>
  factory ProfileModel.fromMap(String uid, Map<String, dynamic> map) {
    return ProfileModel(
      id: uid,
      name: map['name'] as String? ?? 'Utilisateur',
      email: map['email'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      role: map['role'] as String? ?? 'admin',
      phone: map['phone'] as String? ?? '',
      // Firestore stocke les dates comme Timestamp → on convertit
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // ── Vers Firestore ────────────────────────────────────────────
  // Utilisé pour .set() ou .update()
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ── Copie partielle ───────────────────────────────────────────
  // Permet de modifier un seul champ sans réécrire tout l'objet.
  // Exemple : model.copyWith(phone: '0612345678')
  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? role,
    String? phone,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
