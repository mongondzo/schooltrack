import '../../domain/entities/grade_entity.dart';

/// -----------------------------------------------------------------------
/// GradeEvent
/// -----------------------------------------------------------------------
/// Représente toutes les actions que l'UI peut envoyer au GradeBloc,
/// via `context.read<GradeBloc>().add(...)`.
/// -----------------------------------------------------------------------
abstract class GradeEvent {}

/// Demande de charger (ou recharger) la liste de toutes les notes.
class LoadGrades extends GradeEvent {}

/// Demande d'ajouter une nouvelle note.
class AddGrade extends GradeEvent {
  final GradeEntity grade;

  AddGrade(this.grade);
}

/// Demande de modifier une note existante.
class UpdateGrade extends GradeEvent {
  final GradeEntity grade;

  UpdateGrade(this.grade);
}

/// Demande de supprimer une note via son identifiant.
class DeleteGrade extends GradeEvent {
  final String gradeId;

  DeleteGrade(this.gradeId);
}
