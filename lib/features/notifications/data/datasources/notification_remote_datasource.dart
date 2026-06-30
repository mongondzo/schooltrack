import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

/// -----------------------------------------------------------------------
/// NotificationRemoteDataSource
/// -----------------------------------------------------------------------
/// C'est ICI, et SEULEMENT ici, qu'on parle directement à Firestore.
/// Le reste de l'application (Domain, Presentation) ne connaît même pas
/// l'existence de Firestore : il ne connaît que NotificationRepository.
///
/// Collection Firestore utilisée : "notifications"
/// -----------------------------------------------------------------------
class NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  /// Raccourci vers la collection "notifications".
  CollectionReference<Map<String, dynamic>> get _notificationsRef =>
      firestore.collection('notifications');

  /// Récupère toutes les notifications, les plus récentes en premier.
  Future<List<NotificationModel>> getNotifications() async {
    final snapshot =
        await _notificationsRef.orderBy('createdAt', descending: true).get();

    return snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Ajoute une nouvelle notification. Firestore génère automatiquement l'id du document.
  Future<void> addNotification(NotificationModel notification) async {
    await _notificationsRef.add(notification.toMap());
  }

  /// Met à jour une notification existante, identifiée par son id.
  Future<void> updateNotification(NotificationModel notification) async {
    await _notificationsRef.doc(notification.id).update(notification.toMap());
  }

  /// Supprime une notification via son id.
  Future<void> deleteNotification(String id) async {
    await _notificationsRef.doc(id).delete();
  }
}
