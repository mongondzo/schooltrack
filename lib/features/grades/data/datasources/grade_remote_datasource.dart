import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grade_model.dart';

/// -----------------------------------------------------------------------
/// GradeRemoteDataSource
/// -----------------------------------------------------------------------
/// C'est ICI, et SEULEMENT ici, qu'on parle directement à Firestore.
/// Le reste de l'application (Domain, Presentation) ne connaît même pas
/// l'existence de Firestore : il ne connaît que GradeRepository.
///
/// Collection Firestore utilisée : "grades"
/// -----------------------------------------------------------------------
class GradeRemoteDataSource {
  final FirebaseFirestore firestore;

  GradeRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  /// Raccourci vers la collection "grades".
  CollectionReference<Map<String, dynamic>> get _gradesRef =>
      firestore.collection('grades');

  /// Récupère toutes les notes, les plus récentes en premier.
  Future<List<GradeModel>> getGrades() async {
    final snapshot =
        await _gradesRef.orderBy('createdAt', descending: true).get();

    return snapshot.docs
        .map((doc) => GradeModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Ajoute une nouvelle note. Firestore génère automatiquement l'id du document.
  Future<void> addGrade(GradeModel grade) async {
    await _gradesRef.add(grade.toMap());
  }

  /// Met à jour une note existante, identifiée par son id.
  Future<void> updateGrade(GradeModel grade) async {
    await _gradesRef.doc(grade.id).update(grade.toMap());
  }

  /// Supprime une note via son id.
  Future<void> deleteGrade(String id) async {
    await _gradesRef.doc(id).delete();
  }
}
