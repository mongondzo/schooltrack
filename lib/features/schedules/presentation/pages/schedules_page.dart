// ============================================================
// FICHIER : presentation/pages/schedules_page.dart
//
// RÔLE : Page principale de la feature Schedules.
// Affiche tous les créneaux groupés par jour de la semaine,
// avec un filtre par classe et un bouton d'ajout.
//
// FLUX :
//   Page s'ouvre → LoadSchedules → ScheduleLoading → spinner
//                → ScheduleLoaded → liste par jour
//                → ScheduleError  → message d'erreur
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/schedule_card.dart';
import '../widgets/empty_schedules_widget.dart';
import '../../domain/entities/schedule_entity.dart';
import 'add_schedule_page.dart';
import 'edit_schedule_page.dart';
import 'schedule_details_page.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  @override
  void initState() {
    super.initState();
    // Charge les créneaux dès l'ouverture
    context.read<ScheduleBloc>().add(LoadSchedules());
  }

  // Boîte de dialogue de confirmation avant suppression
  Future<void> _confirmDelete(
      BuildContext ctx, String id, String subject) async {
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer le créneau'),
        content: Text(
          'Supprimer "$subject" ?\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style:
                TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && ctx.mounted) {
      ctx.read<ScheduleBloc>().add(DeleteSchedule(id));
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Créneau supprimé'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Emplois du temps',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.blue),
            onPressed: () =>
                context.read<ScheduleBloc>().add(LoadSchedules()),
            tooltip: 'Actualiser',
          ),
        ],
      ),

      // Bouton flottant "+" pour ajouter un créneau
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddSchedulePage()),
        ),
        backgroundColor: AppColors.blue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Ajouter',
          style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          // ── CHARGEMENT ──────────────────────────────────────
          if (state is ScheduleLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(color: AppColors.blue),
            );
          }

          // ── ERREUR ──────────────────────────────────────────
          if (state is ScheduleError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: AppColors.red, size: 48),
                    const SizedBox(height: 12),
                    Text(state.message,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: AppColors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<ScheduleBloc>()
                          .add(LoadSchedules()),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: Colors.white),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── DONNÉES CHARGÉES ────────────────────────────────
          if (state is ScheduleLoaded) {
            final bloc = context.read<ScheduleBloc>();
            final classes = bloc.getClassesDisponibles();
            final byDay = bloc.getSchedulesByDay();

            return Column(
              children: [
                // ── FILTRE PAR CLASSE ─────────────────────────
                if (classes.isNotEmpty)
                  Container(
                    color: AppColors.surface,
                    padding:
                        const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Filtrer par classe',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            )),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Chip "Tous"
                              _FilterChip(
                                label: 'Tous',
                                isSelected:
                                    state.selectedClass == null,
                                onTap: () =>
                                    bloc.filterByClass(null),
                              ),
                              const SizedBox(width: 8),
                              // Un chip par classe
                              ...classes.map(
                                (c) => Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8),
                                  child: _FilterChip(
                                    label: c,
                                    isSelected:
                                        state.selectedClass == c,
                                    onTap: () =>
                                        bloc.filterByClass(c),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // ── LISTE PAR JOUR ────────────────────────────
                Expanded(
                  child: byDay.isEmpty
                      ? EmptySchedulesWidget(
                          message: state.isFiltered
                              ? 'Aucun créneau pour "${state.selectedClass}"'
                              : 'Aucun emploi du temps enregistré',
                          subtitle: state.isFiltered
                              ? null
                              : 'Appuyez sur "Ajouter" pour créer un créneau.',
                        )
                      : ListView(
                          padding:
                              const EdgeInsets.only(bottom: 100),
                          children: byDay.entries.map((entry) {
                            return _DaySection(
                              day: entry.key,
                              schedules: entry.value,
                              onTap: (s) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ScheduleDetailsPage(
                                          schedule: s),
                                ),
                              ),
                              onEdit: (s) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditSchedulePage(
                                          schedule: s),
                                ),
                              ),
                              onDelete: (s) => _confirmDelete(
                                  context, s.id, s.subject),
                            );
                          }).toList(),
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Widget interne : section d'un jour ──────────────────────
class _DaySection extends StatelessWidget {
  final String day;
  final List<ScheduleEntity> schedules;
  final void Function(ScheduleEntity) onTap;
  final void Function(ScheduleEntity) onEdit;
  final void Function(ScheduleEntity) onDelete;

  const _DaySection({
    required this.day,
    required this.schedules,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête du jour
        Padding(
          padding:
              const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${schedules.length} créneau${schedules.length > 1 ? 'x' : ''}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Cartes des créneaux du jour
        ...schedules.map(
          (s) => ScheduleCard(
            schedule: s,
            onTap: () => onTap(s),
            onEdit: () => onEdit(s),
            onDelete: () => onDelete(s),
          ),
        ),
      ],
    );
  }
}

// ── Widget interne : chip de filtre ─────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blue
              : AppColors.fieldBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? AppColors.blue : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected
                ? FontWeight.w600
                : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
