// Formulaire pour créer un nouvel élève.
// Elle utilise le widget StudentForm réutilisable et envoie l'event
// AddStudent au BLoC quand l'utilisateur valide.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import '../widgets/student_form.dart';

class AddStudentPage extends StatelessWidget {
  const AddStudentPage({super.key});

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
          'Ajouter un élève',
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
            // Navigation automatique en arrière après un ajout réussi
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
                // En-tête avec icône
                _buildHeader(),
                const SizedBox(height: 24),

                // Le formulaire réutilisable (champs vides pour l'ajout)
                StudentForm(
                  isLoading: isLoading,
                  submitButtonText: 'Enregistrer l\'élève',
                  onSubmit:
                      ({
                        required String nom,
                        required String prenom,
                        required String classe,
                        required DateTime dateNaissance,
                        required String telephone,
                        required String adresse,
                      }) {
                        // Crée l'objet Student et envoie l'event au BLoC
                        final newStudent = Student(
                          id: '', // Firestore génère l'ID automatiquement
                          nom: nom,
                          prenom: prenom,
                          classe: classe,
                          dateNaissance: dateNaissance,
                          telephoneParent: telephone,
                          adresse: adresse,
                          createdAt: DateTime.now(),
                          schoolId: 'school_001',
                        );

                        context.read<StudentBloc>().add(
                          AddStudent(student: newStudent),
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

  // En-tête de la page
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_add_outlined, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nouvel élève',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Remplissez tous les champs',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
