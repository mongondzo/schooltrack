import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/attendance_entity.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../widgets/attendance_form.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// AddAttendancePage
/// -----------------------------------------------------------------------
/// Page permettant d'ajouter une nouvelle présence.
///
/// Réutilise le widget AttendanceForm, puis envoie un événement
/// AddAttendance au AttendanceBloc déjà fourni par la page parente
/// (AttendancePage).
/// -----------------------------------------------------------------------
class AddAttendancePage extends StatelessWidget {
  const AddAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une présence'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AttendanceForm(
          submitButtonLabel: 'Enregistrer',
          onSubmit: ({
            required studentName,
            required classe,
            required date,
            required status,
          }) {
            // ⚠️ studentId : idéalement, ce champ devrait venir d'une
            // liste déroulante connectée à la feature Students (élève
            // sélectionné dans une liste). Pour rester simple ici, on
            // réutilise le nom saisi.
            final newAttendance = AttendanceEntity(
              id: '',
              studentId: studentName,
              studentName: studentName,
              classe: classe,
              date: date,
              status: status,
              createdAt: DateTime.now(),
            );

            context.read<AttendanceBloc>().add(AddAttendance(newAttendance));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
