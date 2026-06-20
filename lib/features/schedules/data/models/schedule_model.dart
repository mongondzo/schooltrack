// ============================================================
// FICHIER : data/models/schedule_model.dart
//
// RÔLE : Version enrichie de ScheduleEntity qui sait comment
// se convertir vers / depuis Firestore.
//
// Hérite de ScheduleEntity (tous les champs sont hérités)
// et ajoute :
//   fromMap()     → lit un document Firestore → ScheduleModel
//   toMap()       → convertit en Map pour Firestore
//   fromEntity()  → transforme une ScheduleEntity en ScheduleModel
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/schedule_entity.dart';

class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({
    required super.id,
    required super.classId,
    required super.className,
    required super.day,
    required super.subject,
    required super.teacher,
    required super.startTime,
    required super.endTime,
    required super.room,
    required super.createdAt,
  });

  // ── DEPUIS FIRESTORE ───────────────────────────────────────
  // Appelé quand on lit un document.
  // "id"  = identifiant automatique du document Firestore
  // "map" = les champs du document
  factory ScheduleModel.fromMap(String id, Map<String, dynamic> map) {
    return ScheduleModel(
      id: id,
      classId: map['classId'] as String? ?? '',
      className: map['className'] as String? ?? '',
      day: map['day'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      teacher: map['teacher'] as String? ?? '',
      startTime: map['startTime'] as String? ?? '',
      endTime: map['endTime'] as String? ?? '',
      room: map['room'] as String? ?? '',
      // Timestamp Firestore → DateTime Dart
      createdAt:
          (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ── VERS FIRESTORE ─────────────────────────────────────────
  // On ne met pas "id" dans le map car Firestore le gère seul.
  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'className': className,
      'day': day,
      'subject': subject,
      'teacher': teacher,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      // DateTime Dart → Timestamp Firestore
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // ── DEPUIS UNE ENTITÉ ──────────────────────────────────────
  // Quand le BLoC passe une ScheduleEntity et qu'on a besoin
  // d'un ScheduleModel pour appeler Firestore.
  factory ScheduleModel.fromEntity(ScheduleEntity entity) {
    return ScheduleModel(
      id: entity.id,
      classId: entity.classId,
      className: entity.className,
      day: entity.day,
      subject: entity.subject,
      teacher: entity.teacher,
      startTime: entity.startTime,
      endTime: entity.endTime,
      room: entity.room,
      createdAt: entity.createdAt,
    );
  }
}
