import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// GradeForm
/// -----------------------------------------------------------------------
/// Formulaire réutilisable pour AJOUTER ou MODIFIER une note.
///
/// - Pour un AJOUT : ne pas fournir les paramètres `initial...`.
/// - Pour une MODIFICATION : fournir les valeurs actuelles via
///   `initialStudentName`, `initialClasse`, etc.
///
/// `onSubmit` n'est appelé que si TOUS les champs sont valides :
/// - la note doit être comprise entre 0 et 20
/// - le coefficient doit être strictement supérieur à 0
/// -----------------------------------------------------------------------
class GradeForm extends StatefulWidget {
  final String? initialStudentName;
  final String? initialClasse;
  final String? initialMatiere;
  final String? initialNote;
  final String? initialCoefficient;
  final String? initialPeriode;
  final String submitButtonLabel;
  final void Function({
    required String studentName,
    required String classe,
    required String matiere,
    required double note,
    required double coefficient,
    required String periode,
  }) onSubmit;

  const GradeForm({
    super.key,
    this.initialStudentName,
    this.initialClasse,
    this.initialMatiere,
    this.initialNote,
    this.initialCoefficient,
    this.initialPeriode,
    required this.submitButtonLabel,
    required this.onSubmit,
  });

  @override
  State<GradeForm> createState() => _GradeFormState();
}

class _GradeFormState extends State<GradeForm> {
  // La GlobalKey permet de valider et lire le formulaire depuis le code.
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _studentNameController;
  late final TextEditingController _classeController;
  late final TextEditingController _matiereController;
  late final TextEditingController _noteController;
  late final TextEditingController _coefficientController;
  late final TextEditingController _periodeController;

  @override
  void initState() {
    super.initState();
    _studentNameController =
        TextEditingController(text: widget.initialStudentName ?? '');
    _classeController = TextEditingController(text: widget.initialClasse ?? '');
    _matiereController =
        TextEditingController(text: widget.initialMatiere ?? '');
    _noteController = TextEditingController(text: widget.initialNote ?? '');
    _coefficientController =
        TextEditingController(text: widget.initialCoefficient ?? '1');
    _periodeController =
        TextEditingController(text: widget.initialPeriode ?? '');
  }

  @override
  void dispose() {
    // Toujours libérer les controllers pour éviter les fuites de mémoire.
    _studentNameController.dispose();
    _classeController.dispose();
    _matiereController.dispose();
    _noteController.dispose();
    _coefficientController.dispose();
    _periodeController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // On déclenche la validation de tous les champs.
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        studentName: _studentNameController.text.trim(),
        classe: _classeController.text.trim(),
        matiere: _matiereController.text.trim(),
        note: double.parse(_noteController.text.trim()),
        coefficient: double.parse(_coefficientController.text.trim()),
        periode: _periodeController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _studentNameController,
            decoration: const InputDecoration(
              labelText: 'Élève',
              hintText: 'Ex: Jean Dupont',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Le nom de l'élève est obligatoire";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _classeController,
            decoration: const InputDecoration(
              labelText: 'Classe',
              hintText: 'Ex: 6ème A',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La classe est obligatoire';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _matiereController,
            decoration: const InputDecoration(
              labelText: 'Matière',
              hintText: 'Ex: Mathématiques',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La matière est obligatoire';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _noteController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Note',
              hintText: 'Ex: 16',
              suffixText: '/ 20',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La note est obligatoire';
              }
              final parsed = double.tryParse(value.trim());
              if (parsed == null) {
                return 'Entrez un nombre valide';
              }
              if (parsed < 0 || parsed > 20) {
                return 'La note doit être comprise entre 0 et 20';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _coefficientController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Coefficient',
              hintText: 'Ex: 2',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le coefficient est obligatoire';
              }
              final parsed = double.tryParse(value.trim());
              if (parsed == null) {
                return 'Entrez un nombre valide';
              }
              if (parsed <= 0) {
                return 'Le coefficient doit être supérieur à 0';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _periodeController,
            decoration: const InputDecoration(
              labelText: 'Période',
              hintText: 'Ex: Trimestre 1',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La période est obligatoire';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _handleSubmit,
              child: Text(
                widget.submitButtonLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
