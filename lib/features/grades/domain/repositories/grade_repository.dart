import '../entities/grade_entity.dart';

/// -----------------------------------------------------------------------
/// GradeRepository (contrat / interface)
/// -----------------------------------------------------------------------
/// Définit CE QUE la couche Domain attend de la couche Data, sans savoir
/// COMMENT c'est implémenté (Firestore, API REST, base locale...).
///
/// La couche Presentation (GradeBloc) ne parle qu'à cette interface,
/// jamais directement à Firestore.
/// -----------------------------------------------------------------------
abstract class GradeRepository {
  /// Récupère la liste de toutes les notes.
  Future<List<GradeEntity>> getGrades();

  /// Ajoute une nouvelle note.
  Future<void> addGrade(GradeEntity grade);

  /// Met à jour une note existante.
  Future<void> updateGrade(GradeEntity grade);

  /// Supprime une note via son id.
  Future<void> deleteGrade(String id);
}
