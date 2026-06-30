// ════════════════════════════════════════════════════════════════
// MODÈLE : ParentModel (parent_model.dart)
// Couche  : Data
// Rôle    : Étend ParentEntity et sait lire/écrire dans Firestore.
//           C'est la SEULE classe du projet qui connaît le format
//           de stockage Firebase pour les parents.
//
//   Firestore doc  →  fromMap()  →  ParentModel  →  Bloc  →  UI
//   Formulaire UI  →  toMap()    →  Firestore doc
// ════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schooltrack/features/parents/domain/entities/parent_entity.dart';

class ParentModel extends ParentEntity {
  const ParentModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.address,
    required super.childrenIds,
    required super.createdAt,
  });

  // ── Depuis un Map Firestore (méthode fromMap demandée) ────────
  // uid = l'ID du document (passé séparément car pas dans les data)
  // map = le contenu du document (doc.data())
  factory ParentModel.fromMap(String uid, Map<String, dynamic> map) {
    return ParentModel(
      id: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      // childrenIds est stocké comme une liste dans Firestore.
      // On la convertit en List<String> de façon sûre.
      childrenIds: List<String>.from(map['childrenIds'] as List? ?? []),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Raccourci pratique pour construire directement depuis un DocumentSnapshot
  factory ParentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParentModel.fromMap(doc.id, data);
  }

  // ── Vers Firestore (méthode toMap demandée) ────────────────────
  // On n'inclut PAS "id" : Firestore gère l'ID comme clé du document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'childrenIds': childrenIds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ── copyWith : copie avec modifications partielles ─────────────
  // Permet de modifier un seul champ sans réécrire tout l'objet.
  // Exemple : model.copyWith(phone: '0612345678')
  ParentModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    List<String>? childrenIds,
    DateTime? createdAt,
  }) {
    return ParentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      childrenIds: childrenIds ?? this.childrenIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
