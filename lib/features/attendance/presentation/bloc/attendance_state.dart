import '../../domain/entities/attendance_entity.dart';

/// AttendanceState
/// Représente ce que l'UI doit afficher à un instant donné.
/// L'AttendanceBloc émet un nouvel état chaque fois que la situation
/// change, et les widgets (via BlocBuilder) se reconstruisent
/// automatiquement.
abstract class AttendanceState {}

/// État de départ, avant le premier chargement.
class AttendanceInitial extends AttendanceState {}

/// Chargement en cours (ex: pendant un appel Firestore).
class AttendanceLoading extends AttendanceState {}

/// Les présences ont été chargées (ou modifiées) avec succès.
class AttendanceLoaded extends AttendanceState {
  final List<AttendanceEntity> attendanceList;

  AttendanceLoaded(this.attendanceList);
}

/// Une erreur est survenue (chargement, ajout, modification, suppression).
class AttendanceError extends AttendanceState {
  final String message;

  AttendanceError(this.message);
}
