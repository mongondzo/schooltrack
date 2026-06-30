// ============================================================
// FICHIER : domain/repositories/schedule_repository.dart
//
// RÔLE : Contrat (interface abstraite) définissant CE QU'ON
// PEUT FAIRE avec les emplois du temps.
//
// Le BLoC dépend uniquement de cette interface.
// Il ne sait pas si les données viennent de Firestore,
// d'une API REST ou d'une base locale.
//
// C'est le fichier data/repositories/schedule_repository_impl.dart
// qui contiendra le vrai code Firestore.
// ============================================================

import '../entities/schedule_entity.dart';

abstract class ScheduleRepository {
  // Récupère tous les emplois du temps
  Future<List<ScheduleEntity>> getSchedules();

  // Ajoute un nouveau créneau
  Future<void> addSchedule(ScheduleEntity schedule);

  // Modifie un créneau existant
  Future<void> updateSchedule(ScheduleEntity schedule);

  // Supprime un créneau par son id Firestore
  Future<void> deleteSchedule(String id);
}
