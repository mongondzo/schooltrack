// ============================================================
// FICHIER : presentation/bloc/schedule_bloc.dart
//
// RÔLE : Le "cerveau" de la feature Schedules.
//
// Reçoit des ScheduleEvent → appelle le Repository →
// émet des ScheduleState → l'interface se reconstruit.
//
// Contient aussi des méthodes utilitaires appelables depuis
// les pages via context.read<ScheduleBloc>() :
//   getClassesDisponibles()  → liste des classes uniques
//   getDaysOrder()           → ordre des jours de la semaine
//   getSchedulesByDay()      → créneaux groupés par jour
//   countTotal()             → nombre total de créneaux (dashboard)
// ============================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository repository;

  ScheduleBloc({required this.repository}) : super(ScheduleInitial()) {
    on<LoadSchedules>(_onLoad);
    on<AddSchedule>(_onAdd);
    on<UpdateSchedule>(_onUpdate);
    on<DeleteSchedule>(_onDelete);
  }

  // ──────────────────────────────────────────────────────────
  // CHARGER tous les créneaux
  // ──────────────────────────────────────────────────────────
  Future<void> _onLoad(
    LoadSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      final schedules = await repository.getSchedules();
      emit(ScheduleLoaded(
        allSchedules: schedules,
        filteredSchedules: schedules,
      ));
    } catch (e) {
      emit(ScheduleError('Impossible de charger les emplois du temps : $e'));
    }
  }

  // ──────────────────────────────────────────────────────────
  // AJOUTER un créneau puis recharger
  // ──────────────────────────────────────────────────────────
  Future<void> _onAdd(
    AddSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await repository.addSchedule(event.schedule);
      add(LoadSchedules());
    } catch (e) {
      emit(ScheduleError("Impossible d'ajouter le créneau : $e"));
    }
  }

  // ──────────────────────────────────────────────────────────
  // MODIFIER un créneau puis recharger
  // ──────────────────────────────────────────────────────────
  Future<void> _onUpdate(
    UpdateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await repository.updateSchedule(event.schedule);
      add(LoadSchedules());
    } catch (e) {
      emit(ScheduleError('Impossible de modifier le créneau : $e'));
    }
  }

  // ──────────────────────────────────────────────────────────
  // SUPPRIMER un créneau puis recharger
  // ──────────────────────────────────────────────────────────
  Future<void> _onDelete(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await repository.deleteSchedule(event.id);
      add(LoadSchedules());
    } catch (e) {
      emit(ScheduleError('Impossible de supprimer le créneau : $e'));
    }
  }

  // ==========================================================
  // MÉTHODES UTILITAIRES (appelables depuis les pages/widgets)
  // ==========================================================

  // Ordre officiel des jours — utilisé pour trier l'affichage
  static const List<String> daysOrder = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
  ];

  // Liste des classes uniques présentes dans les créneaux chargés.
  // Utilisé pour le menu déroulant du filtre.
  List<String> getClassesDisponibles() {
    final current = state;
    if (current is! ScheduleLoaded) return [];
    final classes =
        current.allSchedules.map((s) => s.className).toSet().toList();
    classes.sort();
    return classes;
  }

  // Filtre la liste par classe.
  // Appelé depuis SchedulesPage quand l'utilisateur choisit une classe.
  // Émet un nouvel état ScheduleLoaded avec la liste filtrée.
  void filterByClass(String? className) {
    final current = state;
    if (current is! ScheduleLoaded) return;

    final filtered = className == null
        ? current.allSchedules
        : current.allSchedules
            .where((s) => s.className == className)
            .toList();

    emit(ScheduleLoaded(
      allSchedules: current.allSchedules,
      filteredSchedules: filtered,
      selectedClass: className,
    ));
  }

  // Groupe les créneaux affichés par jour de la semaine.
  // Retourne une Map où la clé est le jour et la valeur est la liste
  // des créneaux de ce jour, triés par heure de début.
  // Ex : { 'Lundi': [...], 'Mardi': [...] }
  Map<String, List<ScheduleEntity>> getSchedulesByDay() {
    final current = state;
    if (current is! ScheduleLoaded) return {};

    final Map<String, List<ScheduleEntity>> grouped = {};

    for (final day in daysOrder) {
      final daySchedules = current.filteredSchedules
          .where((s) => s.day == day)
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

      if (daySchedules.isNotEmpty) {
        grouped[day] = daySchedules;
      }
    }

    return grouped;
  }

  // Nombre total de créneaux — affiché sur le dashboard.
  int countTotal() {
    final current = state;
    if (current is! ScheduleLoaded) return 0;
    return current.allSchedules.length;
  }
}
