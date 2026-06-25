/// -----------------------------------------------------------------------
/// GradeEntity
/// -----------------------------------------------------------------------
/// Représente une "note" du point de vue MÉTIER (Domain), indépendamment
/// de Firestore ou de toute autre technologie de stockage.
///
/// C'est cet objet que manipulent le GradeBloc et toutes les pages
/// (Presentation). Il ne sait pas d'où il vient ni où il sera enregistré.
/// -----------------------------------------------------------------------
class GradeEntity {
  final String id;
  final String studentId;
  final String studentName;
  final String classe;
  final String matiere;
  final double note;
  final double coefficient;
  final String periode;
  final DateTime createdAt;

  const GradeEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.classe,
    required this.matiere,
    required this.note,
    required this.coefficient,
    required this.periode,
    required this.createdAt,
  });
}
