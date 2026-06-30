import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/grade_entity.dart';
import '../bloc/grade_bloc.dart';
import '../bloc/grade_event.dart';
import '../widgets/grade_form.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// EditGradePage
/// -----------------------------------------------------------------------
/// Page permettant de modifier une note existante.
///
/// Les champs du formulaire sont pré-remplis avec les valeurs actuelles
/// de [grade], grâce aux paramètres `initial...` de GradeForm.
/// -----------------------------------------------------------------------
class EditGradePage extends StatelessWidget {
  final GradeEntity grade;

  const EditGradePage({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la note'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GradeForm(
          initialStudentName: grade.studentName,
          initialClasse: grade.classe,
          initialMatiere: grade.matiere,
          initialNote: grade.note.toString(),
          initialCoefficient: grade.coefficient.toString(),
          initialPeriode: grade.periode,
          submitButtonLabel: 'Enregistrer les modifications',
          onSubmit: ({
            required studentName,
            required classe,
            required matiere,
            required note,
            required coefficient,
            required periode,
          }) {
            // On conserve l'id, le studentId et la date de création
            // d'origine ; seuls les autres champs sont mis à jour.
            final updatedGrade = GradeEntity(
              id: grade.id,
              studentId: grade.studentId,
              studentName: studentName,
              classe: classe,
              matiere: matiere,
              note: note,
              coefficient: coefficient,
              periode: periode,
              createdAt: grade.createdAt,
            );

            context.read<GradeBloc>().add(UpdateGrade(updatedGrade));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
