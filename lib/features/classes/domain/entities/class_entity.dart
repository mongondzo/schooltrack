// ============================================================
// FICHIER : domain/entities/class_entity.dart
//
// RÔLE : L'entité est la représentation "pure" d'une classe
// scolaire dans ton application. Elle ne sait rien de Firestore,
// pas de JSON, pas de base de données. C'est juste un objet Dart
// avec les données dont tu as besoin.
//
// RÈGLE SIMPLE : Si tu changes de base de données demain (ex:
// SQLite), ce fichier ne change PAS. C'est ça la Clean Architecture.
// ============================================================

class ClassEntity {
  final String id;
  final String nomClasse;
  final String niveau;
  final int effectif;
  final String description;
  final DateTime createdAt;

  // Le constructeur "const" permet à Flutter d'optimiser les
  // reconstructions de widgets quand les données ne changent pas.
  const ClassEntity({
    required this.id,
    required this.nomClasse,
    required this.niveau,
    required this.effectif,
    required this.description,
    required this.createdAt,
  });

  // copyWith permet de créer une copie de l'entité en modifiant
  // seulement certains champs. Très utile pour les mises à jour.
  // Exemple : classEntity.copyWith(effectif: 30)
  ClassEntity copyWith({
    String? id,
    String? nomClasse,
    String? niveau,
    int? effectif,
    String? description,
    DateTime? createdAt,
  }) {
    return ClassEntity(
      id: id ?? this.id,
      nomClasse: nomClasse ?? this.nomClasse,
      niveau: niveau ?? this.niveau,
      effectif: effectif ?? this.effectif,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
