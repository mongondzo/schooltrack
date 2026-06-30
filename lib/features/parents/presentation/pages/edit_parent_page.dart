// ════════════════════════════════════════════════════════════════
// PAGE : EditParentPage (edit_parent_page.dart)
// Rôle  : Affiche ParentForm pré-rempli avec les données du parent
//         passé en paramètre. À la validation, construit une
//         ParentEntity mise à jour et envoie UpdateParent au Bloc.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schooltrack/features/parents/domain/entities/parent_entity.dart';
import 'package:schooltrack/features/parents/presentation/bloc/parent_bloc.dart';
import 'package:schooltrack/features/parents/presentation/widgets/parent_form.dart';

class EditParentPage extends StatelessWidget {
  /// Le parent existant à modifier (transmis via GoRouter extra)
  final ParentEntity parent;

  const EditParentPage({super.key, required this.parent});

  // Construit une ParentEntity mise à jour en gardant l'id et createdAt
  void _handleSubmit(BuildContext context, Map<String, dynamic> data) {
    final updatedParent = ParentEntity(
      id: parent.id, // On garde le même ID (obligatoire pour .update())
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      address: data['address'],
      childrenIds: List<String>.from(data['childrenIds']),
      createdAt: parent.createdAt, // La date de création ne change jamais
    );
    context.read<ParentBloc>().add(UpdateParent(updatedParent));
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
          'Modifier le parent',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        elevation: 0,
      ),
      body: BlocListener<ParentBloc, ParentState>(
        listener: (context, state) {
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
                  initialParent: parent, // Pré-remplissage du formulaire
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
