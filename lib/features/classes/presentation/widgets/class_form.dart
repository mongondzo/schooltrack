// ============================================================
// FICHIER : presentation/widgets/class_form.dart
//
// RÔLE : Formulaire réutilisable pour AJOUTER et MODIFIER
// une classe. Le même composant sert dans AddClassPage et
// EditClassPage. Si initialValues est fourni, les champs
// sont pré-remplis (mode édition). Sinon, ils sont vides
// (mode ajout).
// ============================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';

// Données initiales optionnelles pour le mode édition
class ClassFormInitialValues {
  final String nomClasse;
  final String niveau;
  final String effectif;
  final String description;

  const ClassFormInitialValues({
    required this.nomClasse,
    required this.niveau,
    required this.effectif,
    required this.description,
  });
}

class ClassForm extends StatefulWidget {
  // Données pré-remplies si on est en mode édition (null = mode ajout)
  final ClassFormInitialValues? initialValues;

  // Appelé quand le formulaire est validé avec succès.
  // Reçoit les valeurs saisies par l'utilisateur.
  final void Function({
    required String nomClasse,
    required String niveau,
    required int effectif,
    required String description,
  }) onSubmit;

  // Texte du bouton de validation
  final String submitLabel;

  const ClassForm({
    super.key,
    this.initialValues,
    required this.onSubmit,
    this.submitLabel = 'Enregistrer',
  });

  @override
  State<ClassForm> createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  // _formKey permet de déclencher la validation de tous les champs
  // en une seule ligne : _formKey.currentState!.validate()
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs : permettent de lire/écrire dans les champs de texte
  late final TextEditingController _nomController;
  late final TextEditingController _niveauController;
  late final TextEditingController _effectifController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    // Si des valeurs initiales sont fournies (mode édition), on les
    // met dans les contrôleurs. Sinon, les champs commencent vides.
    final v = widget.initialValues;
    _nomController = TextEditingController(text: v?.nomClasse ?? '');
    _niveauController = TextEditingController(text: v?.niveau ?? '');
    _effectifController = TextEditingController(text: v?.effectif ?? '');
    _descController = TextEditingController(text: v?.description ?? '');
  }

  @override
  void dispose() {
    // IMPORTANT : toujours libérer les contrôleurs dans dispose()
    // pour éviter les fuites mémoire.
    _nomController.dispose();
    _niveauController.dispose();
    _effectifController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Style commun pour tous les champs du formulaire.
  // On centralise ici pour ne pas répéter partout.
  InputDecoration _fieldDecoration(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.blue, size: 20),
      filled: true,
      fillColor: AppColors.fieldBackground,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  // Appelé quand l'utilisateur appuie sur le bouton
  void _handleSubmit() {
    // validate() vérifie tous les validator: des TextFormField
    // et retourne true si tout est valide
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      nomClasse: _nomController.text.trim(),
      niveau: _niveauController.text.trim(),
      // On sait que la valeur est un entier valide grâce au validator
      effectif: int.parse(_effectifController.text.trim()),
      description: _descController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Champ : Nom de la classe ---
          TextFormField(
            controller: _nomController,
            decoration: _fieldDecoration(
              'Nom de la classe',
              Icons.class_rounded,
              hint: 'Ex : 6ème A',
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le nom de la classe est obligatoire';
              }
              return null; // null = valide
            },
          ),
          const SizedBox(height: 16),

          // --- Champ : Niveau ---
          TextFormField(
            controller: _niveauController,
            decoration: _fieldDecoration(
              'Niveau',
              Icons.stairs_rounded,
              hint: 'Ex : 6ème, 5ème, Terminale…',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le niveau est obligatoire';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // --- Champ : Effectif ---
          TextFormField(
            controller: _effectifController,
            decoration: _fieldDecoration(
              'Effectif',
              Icons.groups_rounded,
              hint: 'Nombre d\'élèves dans la classe',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'L\'effectif est obligatoire';
              }
              final n = int.tryParse(value.trim());
              if (n == null) {
                return 'Entrez un nombre entier valide';
              }
              if (n < 1) {
                return 'L\'effectif doit être supérieur à 0';
              }
              if (n > 200) {
                return 'L\'effectif semble trop élevé (max 200)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // --- Champ : Description (optionnel) ---
          TextFormField(
            controller: _descController,
            decoration: _fieldDecoration(
              'Description (optionnelle)',
              Icons.notes_rounded,
              hint: 'Informations complémentaires…',
            ),
            maxLines: 3,
            // Pas de validator ici car le champ est optionnel
          ),
          const SizedBox(height: 28),

          // --- Bouton de validation ---
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                widget.submitLabel,
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
