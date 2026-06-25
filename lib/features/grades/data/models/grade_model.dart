import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/grade_entity.dart';

/// -----------------------------------------------------------------------
/// GradeModel
/// -----------------------------------------------------------------------
/// Version "Data" de GradeEntity : elle sait se transformer depuis/vers
/// un Map (le format utilisé par Firestore).
///
/// GradeModel HÉRITE de GradeEntity : partout où une GradeEntity est
/// attendue (Domain, Presentation), une GradeModel peut être utilisée
/// directement, sans conversion supplémentaire.
/// -----------------------------------------------------------------------
class GradeModel extends GradeEntity {
  const GradeModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.classe,
    required super.matiere,
    required super.note,
    required super.coefficient,
    required super.periode,
    required super.createdAt,
  });

  /// Construit un GradeModel à partir d'une GradeEntity du Domain.
  /// Utile dans le repository, juste avant d'envoyer les données à Firestore.
  factory GradeModel.fromEntity(GradeEntity entity) {
    return GradeModel(
      id: entity.id,
      studentId: entity.studentId,
      studentName: entity.studentName,
      classe: entity.classe,
      matiere: entity.matiere,
      note: entity.note,
      coefficient: entity.coefficient,
      periode: entity.periode,
      createdAt: entity.createdAt,
    );
  }

  /// Construit un GradeModel à partir d'un document Firestore.
  /// [map] = les champs du document, [id] = l'id du document (généré par Firestore).
  factory GradeModel.fromMap(Map<String, dynamic> map, String id) {
    return GradeModel(
      id: id,
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      classe: map['classe'] as String? ?? '',
      matiere: map['matiere'] as String? ?? '',
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      coefficient: (map['coefficient'] as num?)?.toDouble() ?? 1.0,
      periode: map['periode'] as String? ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Transforme l'objet en Map pour l'enregistrer dans Firestore.
  /// On n'inclut PAS `id` : c'est l'identifiant du document lui-même,
  /// il n'a pas besoin d'être dupliqué à l'intérieur du document.
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'classe': classe,
      'matiere': matiere,
      'note': note,
      'coefficient': coefficient,
      'periode': periode,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Crée une copie de l'objet en remplaçant uniquement les champs fournis.
  /// Pratique pour modifier une note sans réécrire tous les champs.
  GradeModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? classe,
    String? matiere,
    double? note,
    double? coefficient,
    String? periode,
    DateTime? createdAt,
  }) {
    return GradeModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      classe: classe ?? this.classe,
      matiere: matiere ?? this.matiere,
      note: note ?? this.note,
      coefficient: coefficient ?? this.coefficient,
      periode: periode ?? this.periode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
