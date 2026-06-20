import '../entities/notification_entity.dart';

/// -----------------------------------------------------------------------
/// NotificationRepository (contrat / interface)
/// -----------------------------------------------------------------------
/// Définit CE QUE la couche Domain attend de la couche Data, sans savoir
/// COMMENT c'est implémenté (Firestore, API REST, base locale...).
///
/// La couche Presentation (NotificationBloc) ne parle qu'à cette interface,
/// jamais directement à Firestore.
/// -----------------------------------------------------------------------
abstract class NotificationRepository {
  /// Récupère la liste de toutes les notifications.
  Future<List<NotificationEntity>> getNotifications();

  /// Ajoute une nouvelle notification.
  Future<void> addNotification(NotificationEntity notification);

  /// Met à jour une notification existante.
  Future<void> updateNotification(NotificationEntity notification);

  /// Supprime une notification via son id.
  Future<void> deleteNotification(String id);
}
