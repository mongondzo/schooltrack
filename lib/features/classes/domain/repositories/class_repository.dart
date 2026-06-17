// ============================================================
// FICHIER : domain/repositories/class_repository.dart
//
// RÔLE : C'est un "contrat" - une liste de règles qui dit
// "voici ce qu'on peut faire avec les classes".
//
// Le mot-clé "abstract" signifie que ce fichier ne contient
// pas de code réel. Il dit juste QUOI faire, pas COMMENT le faire.
// C'est la couche DATA (datasource Firestore) qui dira COMMENT.
//
// AVANTAGE : Ton BLoC dépend uniquement de ce contrat.
// Si tu changes Firestore pour une autre base de données,
// tu changes seulement le fichier dans "data/", pas le BLoC.
// ============================================================

import '../entities/class_entity.dart';

abstract class ClassRepository {
  // Récupère toutes les classes depuis la source de données
  Future<List<ClassEntity>> getClasses();

  // Ajoute une nouvelle classe
  Future<void> addClass(ClassEntity classEntity);

  // Modifie une classe existante
  Future<void> updateClass(ClassEntity classEntity);

  // Supprime une classe par son identifiant Firestore
  Future<void> deleteClass(String id);

  // Récupère une seule classe par son id (pour la page détails)
  Future<ClassEntity?> getClassById(String id);
}
