/// -----------------------------------------------------------------------
/// NotificationTargetRole
/// -----------------------------------------------------------------------
/// Les 3 destinataires possibles pour une notification.
///
/// Chaque valeur transporte :
/// - `value`  : le texte enregistré dans Firestore (stable, ne pas traduire)
/// - `label`  : le texte affiché à l'utilisateur (en français)
/// -----------------------------------------------------------------------
enum NotificationTargetRole {
  admin('admin', 'Administrateurs'),
  parent('parent', 'Parents'),
  all('all', 'Tous');

  final String value;
  final String label;

  const NotificationTargetRole(this.value, this.label);

  /// Reconstruit un NotificationTargetRole à partir du texte stocké dans
  /// Firestore. Si la valeur est inconnue, on retombe sur "all" par sécurité.
  static NotificationTargetRole fromValue(String value) {
    return NotificationTargetRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => NotificationTargetRole.all,
    );
  }
}

/// -----------------------------------------------------------------------
/// NotificationEntity
/// -----------------------------------------------------------------------
/// Représente une "notification" du point de vue MÉTIER (Domain),
/// indépendamment de Firestore ou de toute autre technologie de stockage.
///
/// C'est cet objet que manipulent le NotificationBloc et toutes les pages
/// (Presentation).
/// -----------------------------------------------------------------------
class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final NotificationTargetRole targetRole;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.targetRole,
    required this.createdAt,
  });
}
