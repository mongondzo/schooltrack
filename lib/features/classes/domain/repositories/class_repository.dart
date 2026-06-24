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
