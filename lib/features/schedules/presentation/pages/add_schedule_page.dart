// ============================================================
// FICHIER : presentation/pages/add_schedule_page.dart
//
// RÔLE : Page d'ajout d'un nouveau créneau.
// Affiche le ScheduleForm vide, puis au submit :
//   1. Crée une ScheduleEntity
//   2. Envoie AddSchedule au BLoC
//   3. Affiche un message de succès
//   4. Retourne à la liste
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/schedule_form.dart';
import '../../domain/entities/schedule_entity.dart';

class AddSchedulePage extends StatelessWidget {
  const AddSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ajouter un créneau',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
      ),
      // BlocListener écoute les états SANS reconstruire l'interface.
      // Parfait pour afficher des SnackBar après une action.
      body: BlocListener<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Bandeau d'information
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.blue, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Remplissez les informations pour créer un nouveau créneau.',
                        style: TextStyle(
                            color: AppColors.blue, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Formulaire vide (mode ajout)
              ScheduleForm(
                submitLabel: 'Créer le créneau',
                onSubmit: ({
                  required classId,
                  required className,
                  required day,
                  required subject,
                  required teacher,
                  required startTime,
                  required endTime,
                  required room,
                }) {
                  // id vide → Firestore génère l'id automatiquement
                  final schedule = ScheduleEntity(
                    id: '',
                    classId: classId,
                    className: className,
                    day: day,
                    subject: subject,
                    teacher: teacher,
                    startTime: startTime,
                    endTime: endTime,
                    room: room,
                    createdAt: DateTime.now(),
                  );

                  context.read<ScheduleBloc>().add(AddSchedule(schedule));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Créneau ajouté avec succès'),
                      backgroundColor: AppColors.green,
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
