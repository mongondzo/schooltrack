import '../entities/attendance_entity.dart';

/// AttendanceRepository (contrat / interface)
/// Définit CE QUE la couche Domain attend de la couche Data, sans savoir
/// COMMENT c'est implémenté (Firestore, API REST, base locale...).
///
/// La couche Presentation (AttendanceBloc) ne parle qu'à cette interface,
/// jamais directement à Firestore.

abstract class AttendanceRepository {
  /// Récupère la liste de toutes les présences.
  Future<List<AttendanceEntity>> getAttendance();

  /// Ajoute une nouvelle présence.
  Future<void> addAttendance(AttendanceEntity attendance);

  /// Met à jour une présence existante.
  Future<void> updateAttendance(AttendanceEntity attendance);

  /// Supprime une présence via son id.
  Future<void> deleteAttendance(String id);
}
