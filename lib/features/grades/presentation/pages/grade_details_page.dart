import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/grade_entity.dart';
import '../bloc/grade_bloc.dart';
import 'edit_grade_page.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// GradeDetailsPage
/// -----------------------------------------------------------------------
/// Page affichant tous les détails d'une note.
/// -----------------------------------------------------------------------
class GradeDetailsPage extends StatelessWidget {
  final GradeEntity grade;

  const GradeDetailsPage({super.key, required this.grade});

  /// Formate une date en "jj/mm/aaaa" sans dépendance externe (intl).
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GradeBloc>();
    final noteColor = grade.note >= 10 ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la note'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: bloc,
                    child: EditGradePage(grade: grade),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: noteColor.withOpacity(0.1),
              child: Text(
                grade.note.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: noteColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              grade.studentName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          _InfoTile(label: 'Classe', value: grade.classe),
          _InfoTile(label: 'Matière', value: grade.matiere),
          _InfoTile(label: 'Note', value: '${grade.note} / 20'),
          _InfoTile(label: 'Coefficient', value: grade.coefficient.toString()),
          _InfoTile(label: 'Période', value: grade.periode),
          _InfoTile(
            label: 'Date de création',
            value: _formatDate(grade.createdAt),
          ),
        ],
      ),
    );
  }
}

/// Petit widget privé pour afficher une ligne "label : valeur".
class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
