import '../../domain/entities/notification_entity.dart';

abstract class NotificationState {}

/// État de départ, avant le premier chargement.
class NotificationInitial extends NotificationState {}

/// Chargement en cours (ex: pendant un appel Firestore).
class NotificationLoading extends NotificationState {}

/// Les notifications ont été chargées (ou modifiées) avec succès.
class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  NotificationLoaded(this.notifications);
}

/// Une erreur est survenue (chargement, ajout, modification, suppression).
class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
