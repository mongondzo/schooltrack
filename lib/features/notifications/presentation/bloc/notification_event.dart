import '../../domain/entities/notification_entity.dart';

abstract class NotificationEvent {}

/// Demande de charger (ou recharger) la liste de toutes les notifications.
class LoadNotifications extends NotificationEvent {}

/// Demande d'ajouter une nouvelle notification.
class AddNotification extends NotificationEvent {
  final NotificationEntity notification;

  AddNotification(this.notification);
}

/// Demande de modifier une notification existante.
class UpdateNotification extends NotificationEvent {
  final NotificationEntity notification;

  UpdateNotification(this.notification);
}

/// Demande de supprimer une notification via son identifiant.
class DeleteNotification extends NotificationEvent {
  final String notificationId;

  DeleteNotification(this.notificationId);
}
