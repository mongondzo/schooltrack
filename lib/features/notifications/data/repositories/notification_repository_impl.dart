import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

/// -----------------------------------------------------------------------
/// NotificationRepositoryImpl
/// -----------------------------------------------------------------------
/// Implémentation concrète de NotificationRepository (l'interface du
/// Domain).
///
/// Son rôle : faire le pont entre le Domain (qui ne connaît que des
/// NotificationEntity) et la Data (qui parle Firestore via
/// NotificationRemoteDataSource).
/// -----------------------------------------------------------------------
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    // NotificationModel hérite de NotificationEntity : on peut donc
    // renvoyer directement la liste de modèles, elle respecte le contrat.
    return await remoteDataSource.getNotifications();
  }

  @override
  Future<void> addNotification(NotificationEntity notification) async {
    final model = NotificationModel.fromEntity(notification);
    await remoteDataSource.addNotification(model);
  }

  @override
  Future<void> updateNotification(NotificationEntity notification) async {
    final model = NotificationModel.fromEntity(notification);
    await remoteDataSource.updateNotification(model);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await remoteDataSource.deleteNotification(id);
  }
}
