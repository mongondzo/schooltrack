import '../../domain/entities/attendance_entity.dart';

/// AttendanceEvent
/// Représente toutes les actions que l'UI peut envoyer à l'AttendanceBloc,
/// via `context.read<AttendanceBloc>().add(...)`.
abstract class AttendanceEvent {}

/// Demande de charger (ou recharger) la liste de toutes les présences.
class LoadAttendance extends AttendanceEvent {}

/// Demande d'ajouter une nouvelle présence.
class AddAttendance extends AttendanceEvent {
  final AttendanceEntity attendance;

  AddAttendance(this.attendance);
}

/// Demande de modifier une présence existante (y compris changer son statut).
class UpdateAttendance extends AttendanceEvent {
  final AttendanceEntity attendance;

  UpdateAttendance(this.attendance);
}

/// Demande de supprimer une présence via son identifiant.
class DeleteAttendance extends AttendanceEvent {
  final String attendanceId;

  DeleteAttendance(this.attendanceId);
}
