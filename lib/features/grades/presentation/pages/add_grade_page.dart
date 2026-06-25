import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/grade_entity.dart';
import '../bloc/grade_bloc.dart';
import '../bloc/grade_event.dart';
import '../widgets/grade_form.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// AddGradePage
/// -----------------------------------------------------------------------
/// Page permettant d'ajouter une nouvelle note.
///
/// Réutilise le widget GradeForm, puis envoie un événement AddGrade
/// au GradeBloc déjà fourni par la page parente (GradesPage).
/// -----------------------------------------------------------------------
class AddGradePage extends StatelessWidget {
  const AddGradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une note'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GradeForm(
          submitButtonLabel: 'Enregistrer',
          onSubmit: ({
            required studentName,
            required classe,
            required matiere,
            required note,
            required coefficient,
            required periode,
          }) {
            // ⚠️ studentId : idéalement, ce champ devrait venir d'une
            // liste déroulante connectée à la feature Students (élève
            // sélectionné dans une liste). Pour rester simple ici, on
            // réutilise le nom saisi. Tu pourras améliorer ce point plus
            // tard en remplaçant le champ texte "Élève" par un Dropdown.
            final newGrade = GradeEntity(
              id: '',
              studentId: studentName,
              studentName: studentName,
              classe: classe,
              matiere: matiere,
              note: note,
              coefficient: coefficient,
              periode: periode,
              createdAt: DateTime.now(),
            );

            context.read<GradeBloc>().add(AddGrade(newGrade));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
