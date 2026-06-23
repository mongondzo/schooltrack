// PAGE : Liste des élèves
// Page principale de la feature students.
// Affiche la liste de tous les élèves avec une barre de recherche.
//
// Elle utilise BlocConsumer qui combine :
//   - BlocBuilder : reconstruit l'UI quand le State change
//   - BlocListener : réagit aux events sans reconstruire (SnackBar, navigation)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import '../widgets/student_list_tile.dart';
import 'student_detail_page.dart';
import 'add_student_page.dart';
import 'edit_student_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    // Charge les élèves dès que la page est créée
    context.read<StudentBloc>().add(LoadStudents());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Affiche une boîte de dialogue pour confirmer la suppression
  void _confirmDelete(BuildContext context, String studentId, String name) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Voulez-vous vraiment supprimer $name ?\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Déclenche l'événement de suppression dans le BLoC
              context.read<StudentBloc>().add(
                DeleteStudent(studentId: studentId),
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
      appBar: _buildAppBar(context),
      // FloatingActionButton : bouton "+" pour ajouter un élève
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<StudentBloc>(),
                child: const AddStudentPage(),
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.person_add_outlined, color: Colors.white),
        label: const Text(
          'Ajouter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocConsumer<StudentBloc, StudentState>(
        // Le listener réagit à certains états sans reconstruire l'UI
        listener: (context, state) {
          if (state is StudentActionSuccess) {
            // Affiche un message de succès en bas de l'écran
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (state is StudentError) {
            // Affiche un message d'erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        // Le builder reconstruit l'UI selon l'état actuel
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            );
          }

          if (state is StudentError) {
            return _buildErrorState(context, state.message);
          }

          if (state is StudentsLoaded) {
            return _buildStudentList(context, state);
          }

          // État initial : on attend le chargement
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Construction de l'AppBar avec barre de recherche intégrée
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: _isSearchVisible
          ? _buildSearchField(context)
          : const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Élèves',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
      actions: [
        // Bouton pour afficher/masquer la recherche
        IconButton(
          icon: Icon(
            _isSearchVisible ? Icons.close : Icons.search,
            color: const Color(0xFF2563EB),
          ),
          onPressed: () {
            setState(() {
              _isSearchVisible = !_isSearchVisible;
              if (!_isSearchVisible) {
                _searchController.clear();
                // Réinitialise la recherche dans le BLoC
                context.read<StudentBloc>().add(ClearSearch());
              }
            });
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.grey.shade100),
      ),
    );
  }

  // Champ de recherche dans l'AppBar
  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _searchController,
      autofocus: true, // Focus automatique quand on ouvre la recherche
      decoration: const InputDecoration(
        hintText: 'Rechercher un élève...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: (query) {
        // Déclenche la recherche à chaque frappe (debounce naturel du BLoC)
        context.read<StudentBloc>().add(SearchStudents(query: query));
      },
    );
  }

  // Construction de la liste des élèves
  Widget _buildStudentList(BuildContext context, StudentsLoaded state) {
    final students = state.displayStudents;

    if (students.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // En-tête avec le compteur d'élèves
        _buildListHeader(students.length, state.isSearching),

        // Liste scrollable des élèves
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 100), // Espace pour le FAB
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return StudentListTile(
                student: student,
                onTap: () {
                  // Navigue vers la page de détails
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<StudentBloc>(),
                        child: StudentDetailPage(student: student),
                      ),
                    ),
                  );
                },
                onEdit: () {
                  // Navigue vers la page de modification
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
                onDelete: () {
                  // Affiche la boîte de confirmation
                  _confirmDelete(context, student.id, student.nomComplet);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // En-tête de la liste : compteur et filtre actif
  Widget _buildListHeader(int count, bool isSearching) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isSearching ? '$count résultat(s)' : '$count élève(s)',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget affiché quand la liste est vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Aucun élève trouvé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur "Ajouter" pour créer un élève',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // Widget affiché en cas d'erreur
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<StudentBloc>().add(LoadStudents()),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
