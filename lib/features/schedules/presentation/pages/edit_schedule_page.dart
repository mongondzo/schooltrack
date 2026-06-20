// ============================================================
// FICHIER : presentation/pages/edit_schedule_page.dart
//
// RÔLE : Page de modification d'un créneau existant.
// Reçoit la ScheduleEntity à modifier, pré-remplit le formulaire,
// puis au submit envoie UpdateSchedule au BLoC.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/schedule_form.dart';
import '../../domain/entities/schedule_entity.dart';

class EditSchedulePage extends StatelessWidget {
  // Le créneau à modifier, passé depuis SchedulesPage
  final ScheduleEntity schedule;

  const EditSchedulePage({super.key, required this.schedule});

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
          'Modifier le créneau',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
      ),
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
              // Rappel du créneau en cours de modification
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_rounded,
                        color: AppColors.blue, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Modification : ${schedule.subject} — ${schedule.className}',
                        style: const TextStyle(
                            color: AppColors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Formulaire pré-rempli avec les valeurs actuelles
              ScheduleForm(
                initialValues: ScheduleFormValues(
                  classId: schedule.classId,
                  className: schedule.className,
                  day: schedule.day,
                  subject: schedule.subject,
                  teacher: schedule.teacher,
                  startTime: schedule.startTime,
                  endTime: schedule.endTime,
                  room: schedule.room,
                ),
                submitLabel: 'Enregistrer les modifications',
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
                  // copyWith conserve l'id et createdAt d'origine
                  final updated = schedule.copyWith(
                    classId: classId,
                    className: className,
                    day: day,
                    subject: subject,
                    teacher: teacher,
                    startTime: startTime,
                    endTime: endTime,
                    room: room,
                  );

                  context
                      .read<ScheduleBloc>()
                      .add(UpdateSchedule(updated));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('✓ Créneau modifié avec succès'),
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
