/// Les 3 statuts possibles pour une présence.
///
/// Chaque valeur transporte :
/// - `value`  : le texte enregistré dans Firestore (stable, ne pas traduire)
/// - `label`  : le texte affiché à l'utilisateur (en français)
enum AttendanceStatus {
  present('present', 'Présent'),
  absent('absent', 'Absent'),
  lateStatus('late', 'Retard');

  final String value;
  final String label;

  const AttendanceStatus(this.value, this.label);

  /// Reconstruit un AttendanceStatus à partir du texte stocké dans Firestore.
  /// Si la valeur est inconnue, on retombe sur "present" par sécurité.
  static AttendanceStatus fromValue(String value) {
    return AttendanceStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AttendanceStatus.present,
    );
  }
}

/// AttendanceEntity
/// Représente une "présence" du point de vue MÉTIER (Domain), indépendamment
/// de Firestore ou de toute autre technologie de stockage.
///
/// C'est cet objet que manipulent l'AttendanceBloc et toutes les pages
/// (Presentation).
class AttendanceEntity {
  final String id;
  final String studentId;
  final String studentName;
  final String classe;
  final DateTime date;
  final AttendanceStatus status;
  final DateTime createdAt;

  const AttendanceEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.classe,
    required this.date,
    required this.status,
    required this.createdAt,
  });
}
