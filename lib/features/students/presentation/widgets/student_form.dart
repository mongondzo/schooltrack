// WIDGET : Formulaire d'élève (réutilisable pour Ajout ET Modification)
// Ce widget contient tous les champs du formulaire.
// Il est utilisé à la fois sur la page "Ajouter" et "Modifier".
// On évite ainsi de dupliquer le code (principe DRY : Don't Repeat Yourself).
// Les pages n'ont qu'à fournir les valeurs initiales et le callback de soumission.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour le formatage des dates

// Liste des classes disponibles dans l'école
const List<String> kClasses = [
  '6ème A',
  '6ème B',
  '5ème A',
  '5ème B',
  '4ème A',
  '4ème B',
  '3ème A',
  '3ème B',
];

class StudentForm extends StatefulWidget {
  // Valeurs initiales (nulles pour l'ajout, remplies pour la modification)
  final String? initialNom;
  final String? initialPrenom;
  final String? initialClasse;
  final DateTime? initialDateNaissance;
  final String? initialTelephone;
  final String? initialAdresse;

  // Callback appelé quand l'utilisateur soumet le formulaire valide
  final void Function({
    required String nom,
    required String prenom,
    required String classe,
    required DateTime dateNaissance,
    required String telephone,
    required String adresse,
  })
  onSubmit;

  // Texte du bouton de soumission
  final String submitButtonText;

  // Indique si un chargement est en cours (désactive le bouton)
  final bool isLoading;

  const StudentForm({
    super.key,
    this.initialNom,
    this.initialPrenom,
    this.initialClasse,
    this.initialDateNaissance,
    this.initialTelephone,
    this.initialAdresse,
    required this.onSubmit,
    this.submitButtonText = 'Enregistrer',
    this.isLoading = false,
  });

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  // Clé globale pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour chaque champ de texte
  late final TextEditingController _nomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _telephoneController;
  late final TextEditingController _adresseController;

  // État local du formulaire
  String? _selectedClasse;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialise les contrôleurs avec les valeurs initiales (mode édition)
    _nomController = TextEditingController(text: widget.initialNom ?? '');
    _prenomController = TextEditingController(text: widget.initialPrenom ?? '');
    _telephoneController = TextEditingController(
      text: widget.initialTelephone ?? '',
    );
    _adresseController = TextEditingController(
      text: widget.initialAdresse ?? '',
    );
    _selectedClasse = widget.initialClasse;
    _selectedDate = widget.initialDateNaissance;
  }

  @override
  void dispose() {
    // IMPORTANT : libérer les contrôleurs pour éviter les fuites mémoire
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  // Ouvre le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime(2010), // Date par défaut pour un élève typique
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Thème personnalisé pour le picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2563EB)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // Soumet le formulaire après validation
  void _submit() {
    // Vérifie que tous les champs sont valides
    if (!_formKey.currentState!.validate()) return;

    // Vérifie que la date a été sélectionnée (non couverte par validate())
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une date de naissance'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Vérifie que la classe a été sélectionnée
    if (_selectedClasse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une classe'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Tout est valide : on appelle le callback parent
    widget.onSubmit(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      classe: _selectedClasse!,
      dateNaissance: _selectedDate!,
      telephone: _telephoneController.text.trim(),
      adresse: _adresseController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ----- Nom -----
          _buildLabel('Nom de famille'),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _nomController,
            hint: 'Ex: Mongondzo',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le nom est obligatoire';
              }
              if (value.trim().length < 2) {
                return 'Le nom doit contenir au moins 2 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // ----- Prénom -----
          _buildLabel('Prénom'),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _prenomController,
            hint: 'Ex: Nevy Presty',
            icon: Icons.badge_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le prénom est obligatoire';
              }
              if (value.trim().length < 2) {
                return 'Le prénom doit contenir au moins 2 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // ----- Classe -----
          _buildLabel('Classe'),
          const SizedBox(height: 6),
          _buildClasseDropdown(),
          const SizedBox(height: 16),

          // ----- Date de naissance -----
          _buildLabel('Date de naissance'),
          const SizedBox(height: 6),
          _buildDatePicker(context),
          const SizedBox(height: 16),

          // ----- Téléphone parent -----
          _buildLabel('Téléphone parent'),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _telephoneController,
            hint: 'Ex: +242 06 767 38 17',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le téléphone est obligatoire';
              }
              if (value.trim().length < 8) {
                return 'Numéro de téléphone invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // ----- Adresse -----
          _buildLabel('Adresse'),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _adresseController,
            hint: 'Ex: Pointe Noire, Congo Brazzaville',
            icon: Icons.location_on_outlined,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'L\'adresse est obligatoire';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // ----- Bouton de soumission -----
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      widget.submitButtonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Helper : label au-dessus d'un champ
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  // Helper : champ de texte stylisé
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF2563EB), size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  // Helper : dropdown pour sélectionner la classe
  Widget _buildClasseDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedClasse,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.class_outlined,
          color: Color(0xFF2563EB),
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      hint: const Text('Sélectionner une classe'),
      items: kClasses
          .map((classe) => DropdownMenuItem(value: classe, child: Text(classe)))
          .toList(),
      onChanged: (value) => setState(() => _selectedClasse = value),
      validator: (value) =>
          value == null ? 'Veuillez sélectionner une classe' : null,
    );
  }

  // Helper : sélecteur de date
  Widget _buildDatePicker(BuildContext context) {
    final dateText = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : null;

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF2563EB),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              dateText ?? 'Sélectionner une date',
              style: TextStyle(
                fontSize: 16,
                color: dateText != null
                    ? const Color(0xFF1E293B)
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
