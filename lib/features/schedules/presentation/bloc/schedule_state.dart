// ============================================================
// FICHIER : presentation/bloc/schedule_state.dart
//
// RÔLE : Les "states" représentent CE QUE L'INTERFACE AFFICHE.
//
// Flux typique :
//   ScheduleInitial
//     → ScheduleLoading  (appel Firestore en cours)
//     → ScheduleLoaded   (données reçues → affiche la liste)
//     → ScheduleError    (si erreur réseau, Firestore, etc.)
//
// ScheduleLoaded contient :
//   allSchedules      → tous les créneaux depuis Firestore
//   filteredSchedules → créneaux affichés (après filtre classe)
//   selectedClass     → filtre classe actif (null = tous)
// ============================================================

import '../../domain/entities/schedule_entity.dart';

abstract class ScheduleState {}

// État de départ, avant toute action
class ScheduleInitial extends ScheduleState {}

// Chargement en cours → afficher un spinner
class ScheduleLoading extends ScheduleState {}

// Données chargées → afficher la liste
class ScheduleLoaded extends ScheduleState {
  // Liste complète venue de Firestore
  final List<ScheduleEntity> allSchedules;

  // Liste affichée à l'écran (peut être filtrée par classe)
  final List<ScheduleEntity> filteredSchedules;

  // Filtre classe actif (null = on affiche tout)
  final String? selectedClass;

  ScheduleLoaded({
    required this.allSchedules,
    required this.filteredSchedules,
    this.selectedClass,
  });

  // true si un filtre classe est actif
  bool get isFiltered => selectedClass != null;
}

// Erreur survenue → afficher un message
class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);
}
