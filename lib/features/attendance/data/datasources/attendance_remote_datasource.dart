import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model.dart';

/// C'est ICI, et SEULEMENT ici, qu'on parle directement à Firestore.
/// Le reste de l'application (Domain, Presentation) ne connaît même pas
/// l'existence de Firestore : il ne connaît que AttendanceRepository.
///
/// Collection Firestore utilisée : "attendance"
class AttendanceRemoteDataSource {
  final FirebaseFirestore firestore;

  AttendanceRemoteDataSource({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  /// Raccourci vers la collection "attendance".
  CollectionReference<Map<String, dynamic>> get _attendanceRef =>
      firestore.collection('attendance');

  /// Récupère toutes les présences, les plus récentes (par date) en premier.
  Future<List<AttendanceModel>> getAttendance() async {
    final snapshot = await _attendanceRef
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Ajoute une nouvelle présence. Firestore génère automatiquement l'id du document.
  Future<void> addAttendance(AttendanceModel attendance) async {
    await _attendanceRef.add(attendance.toMap());
  }

  /// Met à jour une présence existante, identifiée par son id.
  Future<void> updateAttendance(AttendanceModel attendance) async {
    await _attendanceRef.doc(attendance.id).update(attendance.toMap());
  }

  /// Supprime une présence via son id.
  Future<void> deleteAttendance(String id) async {
    await _attendanceRef.doc(id).delete();
  }
}
