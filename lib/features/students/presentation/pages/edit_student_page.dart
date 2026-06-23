// PAGE : Modifier un élève
// Formulaire pré-rempli pour modifier un élève existant.
// Elle reçoit l'élève à modifier et envoie l'event UpdateStudent au BLoC.
//
// Différence avec AddStudentPage : les champs sont pré-remplis
// avec les données actuelles de l'élève.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import '../widgets/student_form.dart';
import '../widgets/student_avatar.dart';

class EditStudentPage extends StatelessWidget {
  // L'élève à modifier, reçu depuis la page précédente
  final Student student;

  const EditStudentPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Modifier l\'élève',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade100),
        ),
      ),
      body: BlocConsumer<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentActionSuccess) {
            // Navigation automatique en arrière après modification
            Navigator.pop(context);
          } else if (state is StudentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is StudentLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // En-tête avec l'avatar de l'élève
                _buildHeader(),
                const SizedBox(height: 24),

                // Formulaire pré-rempli avec les données actuelles
                StudentForm(
                  // On passe les valeurs initiales pour pré-remplir les champs
                  initialNom: student.nom,
                  initialPrenom: student.prenom,
                  initialClasse: student.classe,
                  initialDateNaissance: student.dateNaissance,
                  initialTelephone: student.telephoneParent,
                  initialAdresse: student.adresse,
                  isLoading: isLoading,
                  submitButtonText: 'Enregistrer les modifications',
                  onSubmit:
                      ({
                        required String nom,
                        required String prenom,
                        required String classe,
                        required DateTime dateNaissance,
                        required String telephone,
                        required String adresse,
                      }) {
                        // Crée une copie de l'élève avec les nouvelles valeurs
                        // On garde le même ID et createdAt (pas de changement)
                        final updatedStudent = student.copyWith(
                          nom: nom,
                          prenom: prenom,
                          classe: classe,
                          dateNaissance: dateNaissance,
                          telephoneParent: telephone,
                          adresse: adresse,
                        );

                        context.read<StudentBloc>().add(
                          UpdateStudent(student: updatedStudent),
                        );
                      },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Avatar de l'élève en cours de modification
          StudentAvatar(student: student, radius: 32, fontSize: 20),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.nomComplet,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  student.classe,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
