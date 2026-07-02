import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/attendance_entity.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../widgets/attendance_form.dart';

const _primaryColor = Color(0xFF2563EB);

/// Page permettant de modifier une présence existante.
///
/// Les champs du formulaire sont pré-remplis avec les valeurs actuelles
/// de [attendance], grâce aux paramètres `initial...` de AttendanceForm.

class EditAttendancePage extends StatelessWidget {
  final AttendanceEntity attendance;

  const EditAttendancePage({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la présence'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AttendanceForm(
          initialStudentName: attendance.studentName,
          initialClasse: attendance.classe,
          initialDate: attendance.date,
          initialStatus: attendance.status,
          submitButtonLabel: 'Enregistrer les modifications',
          onSubmit:
              ({
                required studentName,
                required classe,
                required date,
                required status,
              }) {
                // On conserve l'id, le studentId et la date de création
                // d'origine ; seuls les autres champs sont mis à jour.
                final updatedAttendance = AttendanceEntity(
                  id: attendance.id,
                  studentId: attendance.studentId,
                  studentName: studentName,
                  classe: classe,
                  date: date,
                  status: status,
                  createdAt: attendance.createdAt,
                );

                context.read<AttendanceBloc>().add(
                  UpdateAttendance(updatedAttendance),
                );
                Navigator.pop(context);
              },
        ),
      ),
    );
  }
}
