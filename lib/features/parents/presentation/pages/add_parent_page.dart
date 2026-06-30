// ════════════════════════════════════════════════════════════════
// PAGE : AddParentPage (add_parent_page.dart)
// Rôle  : Affiche le formulaire ParentForm en mode "ajout"
//         (aucune donnée initiale). À la validation, construit
//         une ParentEntity et envoie l'event AddParent au Bloc.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schooltrack/features/parents/domain/entities/parent_entity.dart';
import 'package:schooltrack/features/parents/presentation/bloc/parent_bloc.dart';
import 'package:schooltrack/features/parents/presentation/widgets/parent_form.dart';

class AddParentPage extends StatelessWidget {
  const AddParentPage({super.key});

  // Construit une nouvelle ParentEntity et déclenche l'ajout via le Bloc
  void _handleSubmit(BuildContext context, Map<String, dynamic> data) {
    final newParent = ParentEntity(
      id: '', // Firestore génère l'ID automatiquement via .add()
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      address: data['address'],
      childrenIds: List<String>.from(data['childrenIds']),
      createdAt: DateTime.now(),
    );
    context.read<ParentBloc>().add(AddParent(newParent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Ajouter un parent',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        elevation: 0,
      ),
      // BlocListener réagit aux changements d'état SANS reconstruire la page
      body: BlocListener<ParentBloc, ParentState>(
        listener: (context, state) {
          // Si l'ajout réussit (ParentLoaded avec message) → on revient en arrière
          if (state is ParentLoaded && state.message != null) {
            context.pop();
          }
          if (state is ParentError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message,
                  style: GoogleFonts.poppins(fontSize: 13)),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ));
          }
        },
        child: BlocBuilder<ParentBloc, ParentState>(
          builder: (context, state) {
            final isLoading = state is ParentLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ParentForm(
                  isLoading: isLoading,
                  onSubmit: (data) => _handleSubmit(context, data),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
