import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

/// -----------------------------------------------------------------------
/// NotificationModel
/// -----------------------------------------------------------------------
/// Version "Data" de NotificationEntity : elle sait se transformer
/// depuis/vers un Map (le format utilisé par Firestore).
///
/// NotificationModel HÉRITE de NotificationEntity : partout où une
/// NotificationEntity est attendue (Domain, Presentation), une
/// NotificationModel peut être utilisée directement.
/// -----------------------------------------------------------------------
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.targetRole,
    required super.createdAt,
  });

  /// Construit un NotificationModel à partir d'une NotificationEntity du
  /// Domain. Utile dans le repository, juste avant d'envoyer les données
  /// à Firestore.
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      targetRole: entity.targetRole,
      createdAt: entity.createdAt,
    );
  }

  /// Construit un NotificationModel à partir d'un document Firestore.
  /// [map] = les champs du document, [id] = l'id du document (généré par Firestore).
  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      targetRole:
          NotificationTargetRole.fromValue(map['targetRole'] as String? ?? 'all'),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Transforme l'objet en Map pour l'enregistrer dans Firestore.
  /// On n'inclut PAS `id` : c'est l'identifiant du document lui-même.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'targetRole': targetRole.value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Crée une copie de l'objet en remplaçant uniquement les champs fournis.
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationTargetRole? targetRole,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      targetRole: targetRole ?? this.targetRole,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
