import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/class_entity.dart';

class ClassModel extends ClassEntity {
  const ClassModel({
    required super.id,
    required super.nomClasse,
    required super.niveau,
    required super.effectif,
    required super.description,
    required super.createdAt,
  });

  // --- DEPUIS FIRESTORE ---
  // Appelé quand on lit un document depuis Firestore.
  // "doc.id" = l'identifiant automatique généré par Firestore
  // "map" = les données du document (les champs)
  factory ClassModel.fromMap(String id, Map<String, dynamic> map) {
    return ClassModel(
      id: id,
      nomClasse: map['nomClasse'] as String? ?? '',
      niveau: map['niveau'] as String? ?? '',
      // Firestore peut stocker des int ou des double, on sécurise la
      // conversion avec num puis toInt().
      effectif: (map['effectif'] as num?)?.toInt() ?? 0,
      description: map['description'] as String? ?? '',
      // Firestore stocke les dates comme "Timestamp", on le convertit
      // en DateTime Dart standard.
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // --- VERS FIRESTORE ---
  // Appelé quand on veut sauvegarder/modifier dans Firestore.
  // On ne met pas "id" dans le map car Firestore le gère séparément.
  Map<String, dynamic> toMap() {
    return {
      'nomClasse': nomClasse,
      'niveau': niveau,
      'effectif': effectif,
      'description': description,
      // On reconvertit le DateTime en Timestamp pour Firestore.
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // --- DEPUIS UNE ENTITÉ ---
  // Utile quand le BLoC envoie une ClassEntity et qu'on a besoin
  // d'un ClassModel pour appeler Firestore.
  factory ClassModel.fromEntity(ClassEntity entity) {
    return ClassModel(
      id: entity.id,
      nomClasse: entity.nomClasse,
      niveau: entity.niveau,
      effectif: entity.effectif,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }
}
