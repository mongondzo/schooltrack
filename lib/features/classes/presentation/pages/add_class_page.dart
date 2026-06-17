// ============================================================
// FICHIER : presentation/pages/add_class_page.dart
//
// RÔLE : Page pour ajouter une nouvelle classe.
// Elle affiche le formulaire ClassForm en mode "ajout" (vide).
//
// Quand l'utilisateur valide :
//   1. On crée une ClassEntity avec les valeurs du formulaire
//   2. On envoie AddClass(entity) au BLoC
//   3. Le BLoC enregistre dans Firestore et recharge la liste
//   4. On affiche un message de succès et on revient en arrière
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/class_bloc.dart';
import '../bloc/class_event.dart';
import '../bloc/class_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/class_form.dart';
import '../../domain/entities/class_entity.dart';

class AddClassPage extends StatelessWidget {
  const AddClassPage({super.key});

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
          'Ajouter une classe',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            fontSize: 18,
          ),
        ),
      ),
      // BlocListener écoute les changements d'état SANS reconstruire
      // l'interface. Il est parfait pour les effets de bord : navigation,
      // affichage de SnackBar, etc.
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
              // En-tête descriptif
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.blue, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Remplissez les informations pour créer une nouvelle classe.',
                        style:
                            TextStyle(color: AppColors.blue, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Formulaire (mode ajout : pas de initialValues)
              ClassForm(
                submitLabel: 'Créer la classe',
                onSubmit: ({
                  required nomClasse,
                  required niveau,
                  required effectif,
                  required description,
                }) {
                  // On crée l'entité avec id vide.
                  // Firestore générera un id unique automatiquement
                  // via .add() dans le datasource.
                  final entity = ClassEntity(
                    id: '',
                    nomClasse: nomClasse,
                    niveau: niveau,
                    effectif: effectif,
                    description: description,
                    createdAt: DateTime.now(),
                  );

                  // Envoi de l'event au BLoC
                  context.read<ClassBloc>().add(AddClass(entity));

                  // Message de confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Classe ajoutée avec succès'),
                      backgroundColor: AppColors.green,
                    ),
                  );

                  // Retour à la liste
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
