// ============================================================
// FICHIER : presentation/widgets/schedule_stat_card.dart
//
// RÔLE : Carte statistique pour le Dashboard.
// Affiche le nombre total de créneaux enregistrés.
//
// UTILISATION dans ton DashboardPage :
//
//   import 'features/schedules/presentation/widgets/schedule_stat_card.dart';
//
//   // Dans ta grille de statistiques :
//   ScheduleStatCard(
//     onTap: () => Navigator.pushNamed(context, ScheduleRoutes.list),
//   )
//
// Le ScheduleBloc doit être fourni par un BlocProvider ancêtre
// (dans MultiBlocProvider de main.dart).
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import 'app_colors.dart';

class ScheduleStatCard extends StatefulWidget {
  // Callback appelé quand l'utilisateur appuie sur la carte
  final VoidCallback? onTap;

  const ScheduleStatCard({super.key, this.onTap});

  @override
  State<ScheduleStatCard> createState() => _ScheduleStatCardState();
}

class _ScheduleStatCardState extends State<ScheduleStatCard> {
  @override
  void initState() {
    super.initState();
    // Charge les créneaux si ce n'est pas déjà fait
    final bloc = context.read<ScheduleBloc>();
    if (bloc.state is ScheduleInitial) {
      bloc.add(LoadSchedules());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        final total = state is ScheduleLoaded ? state.allSchedules.length : 0;
        final isLoading = state is ScheduleLoading;

        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    if (isLoading)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Emplois du temps',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Voir plus →',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
