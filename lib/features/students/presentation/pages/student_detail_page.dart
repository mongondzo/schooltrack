// PAGE : Détails d'un élève
// Affiche toutes les informations d'un élève en lecture seule.
// Propose des boutons pour modifier ou supprimer l'élève.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import '../widgets/student_avatar.dart';
import 'edit_student_page.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  // Ouvre une confirmation avant de supprimer
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer cet élève ?'),
        content: Text('${student.nomComplet} sera définitivement supprimé.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<StudentBloc>().add(
                DeleteStudent(studentId: student.id),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocListener<StudentBloc, StudentState>(
        // Écoute seulement pour la suppression (naviguer en arrière)
        listener: (context, state) {
          if (state is StudentActionSuccess) {
            // Ferme cette page ET la liste si l'élève a été supprimé
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: CustomScrollView(
          slivers: [
            // AppBar avec dégradé et avatar
            _buildSliverAppBar(context),
            // Corps de la page avec les informations
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section : Informations personnelles
                    _buildInfoCard(
                      title: 'Informations personnelles',
                      icon: Icons.person_outline,
                      children: [
                        _buildInfoRow(
                          'Nom complet',
                          student.nomComplet,
                          Icons.badge_outlined,
                        ),
                        _buildInfoRow(
                          'Classe',
                          student.classe,
                          Icons.class_outlined,
                        ),
                        _buildInfoRow(
                          'Date de naissance',
                          DateFormat(
                            'dd MMMM yyyy',
                            'fr',
                          ).format(student.dateNaissance),
                          Icons.cake_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section : Coordonnées
                    _buildInfoCard(
                      title: 'Coordonnées',
                      icon: Icons.contact_phone_outlined,
                      children: [
                        _buildInfoRow(
                          'Téléphone parent',
                          student.telephoneParent,
                          Icons.phone_outlined,
                        ),
                        _buildInfoRow(
                          'Adresse',
                          student.adresse,
                          Icons.location_on_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section : Métadonnées
                    _buildInfoCard(
                      title: 'Informations système',
                      icon: Icons.info_outline,
                      children: [
                        _buildInfoRow('ID', student.id, Icons.fingerprint),
                        _buildInfoRow(
                          'Créé le',
                          DateFormat(
                            'dd/MM/yyyy à HH:mm',
                          ).format(student.createdAt),
                          Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Boutons d'action
                    _buildActionButtons(context),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AppBar avec dégradé bleu et grand avatar
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: const Color(0xFF2563EB),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // Bouton modifier dans l'AppBar
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<StudentBloc>(),
                  child: EditStudentPage(student: student),
                ),
              ),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60), // Espace pour l'AppBar
              // Grand avatar
              StudentAvatar(student: student, radius: 44, fontSize: 28),
              const SizedBox(height: 12),
              Text(
                student.nomComplet,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              // Badge de classe
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  student.classe,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Carte d'informations avec titre et liste de lignes
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de la carte
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF2563EB), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          // Lignes d'information
          ...children,
        ],
      ),
    );
  }

  // Ligne d'information : label + valeur
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Boutons Modifier et Supprimer en bas de la page
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Bouton Modifier
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<StudentBloc>(),
                    child: EditStudentPage(student: student),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Modifier'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              side: const BorderSide(color: Color(0xFF2563EB)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Bouton Supprimer
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Supprimer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
