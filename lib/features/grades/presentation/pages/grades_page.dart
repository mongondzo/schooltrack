import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/grade_entity.dart';
import '../../domain/repositories/grade_repository.dart';
import '../bloc/grade_bloc.dart';
import '../bloc/grade_event.dart';
import '../bloc/grade_state.dart';
import '../widgets/grade_card.dart';
import '../widgets/empty_grades_widget.dart';
import 'add_grade_page.dart';
import 'edit_grade_page.dart';
import 'grade_details_page.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// GradesPage
/// -----------------------------------------------------------------------
/// Page principale de la fonctionnalité Grades.
///
/// C'est ICI que le GradeBloc est créé et fourni (BlocProvider) à tout
/// l'arbre de widgets : la page elle-même, et toutes les pages poussées
/// par-dessus (Add/Edit/Details), qui réutilisent le même bloc.
///
/// `repository` doit être l'implémentation concrète de GradeRepository
/// fournie par la couche Data (GradeRepositoryImpl).
/// -----------------------------------------------------------------------
class GradesPage extends StatelessWidget {
  final GradeRepository repository;

  const GradesPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GradeBloc(repository)..add(LoadGrades()),
      child: const _GradesView(),
    );
  }
}

/// Vue interne : sépare la logique d'affichage de la création du bloc.
class _GradesView extends StatefulWidget {
  const _GradesView();

  @override
  State<_GradesView> createState() => _GradesViewState();
}

class _GradesViewState extends State<_GradesView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtre simple, en mémoire, sur l'élève, la matière ou la classe.
  List<GradeEntity> _filter(List<GradeEntity> grades) {
    if (_query.trim().isEmpty) return grades;
    final query = _query.toLowerCase();
    return grades
        .where((g) =>
            g.studentName.toLowerCase().contains(query) ||
            g.matiere.toLowerCase().contains(query) ||
            g.classe.toLowerCase().contains(query))
        .toList();
  }

  void _goToAddPage(BuildContext context) {
    final bloc = context.read<GradeBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const AddGradePage(),
        ),
      ),
    );
  }

  void _goToEditPage(BuildContext context, GradeEntity grade) {
    final bloc = context.read<GradeBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: EditGradePage(grade: grade),
        ),
      ),
    );
  }

  void _goToDetailsPage(BuildContext context, GradeEntity grade) {
    final bloc = context.read<GradeBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: GradeDetailsPage(grade: grade),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, GradeEntity grade) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer la note'),
        content: Text(
          'Voulez-vous vraiment supprimer la note de "${grade.studentName}" en ${grade.matiere} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<GradeBloc>().add(DeleteGrade(grade.id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: () => _goToAddPage(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Barre de recherche simple (filtrage local, en mémoire).
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Rechercher un élève, une matière...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<GradeBloc, GradeState>(
              builder: (context, state) {
                if (state is GradeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: _primaryColor),
                  );
                }

                if (state is GradeError) {
                  return Center(child: Text(state.message));
                }

                if (state is GradeLoaded) {
                  final filtered = _filter(state.grades);

                  if (filtered.isEmpty) {
                    return const EmptyGradesWidget();
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final grade = filtered[index];
                      return GradeCard(
                        grade: grade,
                        onTap: () => _goToDetailsPage(context, grade),
                        onEdit: () => _goToEditPage(context, grade),
                        onDelete: () => _confirmDelete(context, grade),
                      );
                    },
                  );
                }

                // Cas de GradeInitial : rien à afficher pour l'instant.
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
