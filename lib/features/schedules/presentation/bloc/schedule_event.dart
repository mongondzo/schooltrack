// ============================================================
// FICHIER : presentation/bloc/schedule_event.dart
//
// RÔLE : Les "events" sont les ACTIONS que l'utilisateur
// peut déclencher depuis l'interface.
//
//   Page s'ouvre            → LoadSchedules
//   Formulaire validé ajout → AddSchedule
//   Formulaire validé modif → UpdateSchedule
//   Confirmation suppression→ DeleteSchedule
// ============================================================

import '../../domain/entities/schedule_entity.dart';

// Classe mère de tous les events
abstract class ScheduleEvent {}

// Charge tous les créneaux depuis Firestore
class LoadSchedules extends ScheduleEvent {}

// Ajoute un nouveau créneau
class AddSchedule extends ScheduleEvent {
  final ScheduleEntity schedule;
  AddSchedule(this.schedule);
}

// Modifie un créneau existant
class UpdateSchedule extends ScheduleEvent {
  final ScheduleEntity schedule;
  UpdateSchedule(this.schedule);
}

// Supprime un créneau par son id
class DeleteSchedule extends ScheduleEvent {
  final String id;
  DeleteSchedule(this.id);
}
