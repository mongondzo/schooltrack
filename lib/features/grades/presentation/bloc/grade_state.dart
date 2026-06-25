import '../../domain/entities/grade_entity.dart';

/// -----------------------------------------------------------------------
/// GradeState
/// -----------------------------------------------------------------------
/// Représente ce que l'UI doit afficher à un instant donné.
/// Le GradeBloc émet un nouvel état chaque fois que la situation change,
/// et les widgets (via BlocBuilder) se reconstruisent automatiquement.
/// -----------------------------------------------------------------------
abstract class GradeState {}

/// État de départ, avant le premier chargement.
class GradeInitial extends GradeState {}

/// Chargement en cours (ex: pendant un appel Firestore).
class GradeLoading extends GradeState {}

/// Les notes ont été chargées (ou modifiées) avec succès.
class GradeLoaded extends GradeState {
  final List<GradeEntity> grades;

  GradeLoaded(this.grades);
}

/// Une erreur est survenue (chargement, ajout, modification, suppression).
class GradeError extends GradeState {
  final String message;

  GradeError(this.message);
}
