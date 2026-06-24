// ============================================================
// FICHIER : presentation/pages/edit_class_page.dart
//
// RÔLE : Page pour modifier une classe existante.
// Elle reçoit la ClassEntity à modifier et pré-remplit
// le formulaire avec ses valeurs actuelles.
//
// Quand l'utilisateur valide :
//   1. On crée une nouvelle ClassEntity avec les nouvelles valeurs
//      mais en CONSERVANT l'id et createdAt d'origine
//   2. On envoie UpdateClass(entity) au BLoC
//   3. Le BLoC met à jour Firestore et recharge la liste
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/class_bloc.dart';
import '../bloc/class_event.dart';
import '../bloc/class_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/class_form.dart';
import '../../domain/entities/class_entity.dart';

class EditClassPage extends StatelessWidget {
  // La classe à modifier, passée depuis ClassesPage
  final ClassEntity classEntity;

  const EditClassPage({super.key, required this.classEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Modifier la classe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<ClassBloc, ClassState>(
        listener: (context, state) {
          if (state is ClassError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Rappel : nom de la classe modifiée
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_rounded,
                        color: AppColors.blue, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Modification de : ${classEntity.nomClasse}',
                        style: const TextStyle(
                            color: AppColors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Formulaire en mode édition : les champs sont pré-remplis
              ClassForm(
                // Les valeurs actuelles pré-remplissent le formulaire
                initialValues: ClassFormInitialValues(
                  nomClasse: classEntity.nomClasse,
                  niveau: classEntity.niveau,
                  effectif: classEntity.effectif.toString(),
                  description: classEntity.description,
                ),
                submitLabel: 'Enregistrer les modifications',
                onSubmit: ({
                  required nomClasse,
                  required niveau,
                  required effectif,
                  required description,
                }) {
                  // copyWith conserve l'id et createdAt d'origine,
                  // et met à jour uniquement les champs modifiés.
                  final updatedEntity = classEntity.copyWith(
                    nomClasse: nomClasse,
                    niveau: niveau,
                    effectif: effectif,
                    description: description,
                  );

                  context.read<ClassBloc>().add(UpdateClass(updatedEntity));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Classe modifiée avec succès'),
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
