import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/attendance_entity.dart';

/// Version "Data" de AttendanceEntity : elle sait se transformer
/// depuis/vers un Map (le format utilisé par Firestore).
///
/// AttendanceModel HÉRITE de AttendanceEntity : partout où une
/// AttendanceEntity est attendue (Domain, Presentation), une
/// AttendanceModel peut être utilisée directement.
class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.classe,
    required super.date,
    required super.status,
    required super.createdAt,
  });

  /// Construit un AttendanceModel à partir d'une AttendanceEntity du Domain.
  /// Utile dans le repository, juste avant d'envoyer les données à Firestore.
  factory AttendanceModel.fromEntity(AttendanceEntity entity) {
    return AttendanceModel(
      id: entity.id,
      studentId: entity.studentId,
      studentName: entity.studentName,
      classe: entity.classe,
      date: entity.date,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  /// Construit un AttendanceModel à partir d'un document Firestore.
  /// [map] = les champs du document, [id] = l'id du document (généré par Firestore).
  factory AttendanceModel.fromMap(Map<String, dynamic> map, String id) {
    return AttendanceModel(
      id: id,
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      classe: map['classe'] as String? ?? '',
      date: map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
      status: AttendanceStatus.fromValue(map['status'] as String? ?? 'present'),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Transforme l'objet en Map pour l'enregistrer dans Firestore.
  /// On n'inclut PAS `id` : c'est l'identifiant du document lui-même.
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'classe': classe,
      'date': Timestamp.fromDate(date),
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Crée une copie de l'objet en remplaçant uniquement les champs fournis.
  AttendanceModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? classe,
    DateTime? date,
    AttendanceStatus? status,
    DateTime? createdAt,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      classe: classe ?? this.classe,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
