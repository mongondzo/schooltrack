// ============================================================
// FICHIER : data/datasources/schedule_remote_datasource.dart
//
// RÔLE : SEUL fichier qui parle directement à Firestore.
// Toutes les opérations CRUD sur la collection "schedules"
// sont centralisées ici.
//
// Si tu changes de base de données demain,
// seul CE fichier est à modifier.
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_model.dart';

class ScheduleRemoteDataSource {
  final FirebaseFirestore _firestore;

  ScheduleRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Référence rapide vers la collection Firestore "schedules"
  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('schedules');

  // ──────────────────────────────────────────────────────────
  // LIRE tous les créneaux
  // Triés par jour puis par heure de début pour un affichage
  // logique dans les pages.
  // ──────────────────────────────────────────────────────────
  Future<List<ScheduleModel>> getSchedules() async {
    final snapshot = await _col
        .orderBy('day')
        .orderBy('startTime')
        .get();

    return snapshot.docs
        .map((doc) => ScheduleModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  // ──────────────────────────────────────────────────────────
  // AJOUTER un créneau
  // .add() laisse Firestore générer un id unique automatiquement
  // ──────────────────────────────────────────────────────────
  Future<void> addSchedule(ScheduleModel schedule) async {
    await _col.add(schedule.toMap());
  }

  // ──────────────────────────────────────────────────────────
  // MODIFIER un créneau existant
  // .update() ne touche que les champs fournis
  // ──────────────────────────────────────────────────────────
  Future<void> updateSchedule(ScheduleModel schedule) async {
    await _col.doc(schedule.id).update(schedule.toMap());
  }

  // ──────────────────────────────────────────────────────────
  // SUPPRIMER un créneau définitivement
  // ──────────────────────────────────────────────────────────
  Future<void> deleteSchedule(String id) async {
    await _col.doc(id).delete();
  }
}
