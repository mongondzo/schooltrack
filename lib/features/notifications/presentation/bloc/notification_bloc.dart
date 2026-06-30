import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<AddNotification>(_onAddNotification);
    on<UpdateNotification>(_onUpdateNotification);
    on<DeleteNotification>(_onDeleteNotification);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final notifications = await repository.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError('Impossible de charger les notifications : $e'));
    }
  }

  Future<void> _onAddNotification(
    AddNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.addNotification(event.notification);
      // On recharge la liste pour que l'UI affiche la nouvelle notification.
      await _onLoadNotifications(LoadNotifications(), emit);
    } catch (e) {
      emit(NotificationError("Impossible d'ajouter la notification : $e"));
    }
  }

  Future<void> _onUpdateNotification(
    UpdateNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.updateNotification(event.notification);
      await _onLoadNotifications(LoadNotifications(), emit);
    } catch (e) {
      emit(NotificationError('Impossible de modifier la notification : $e'));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.deleteNotification(event.notificationId);
      await _onLoadNotifications(LoadNotifications(), emit);
    } catch (e) {
      emit(NotificationError('Impossible de supprimer la notification : $e'));
    }
  }
}
