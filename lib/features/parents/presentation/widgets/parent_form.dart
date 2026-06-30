// ════════════════════════════════════════════════════════════════
// WIDGET : ParentForm (parent_form.dart)
// Rôle   : Formulaire RÉUTILISABLE partagé entre AddParentPage
//          et EditParentPage.
//          [initialParent] null  → mode ajout (champs vides)
//          [initialParent] fourni → mode modification (pré-rempli)
//          [onSubmit] est appelé avec les données si le formulaire
//          passe la validation.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schooltrack/features/parents/domain/entities/parent_entity.dart';
import 'package:schooltrack/features/parents/presentation/widgets/parent_children_selector.dart';

class ParentForm extends StatefulWidget {
  final ParentEntity? initialParent;
  final void Function(Map<String, dynamic> data) onSubmit;
  final bool isLoading;

  const ParentForm({
    super.key,
    this.initialParent,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<ParentForm> createState() => _ParentFormState();
}

class _ParentFormState extends State<ParentForm> {
  // Clé du formulaire pour déclencher la validation de tous les champs
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  // Liste des IDs d'enfants sélectionnés via ParentChildrenSelector
  late List<String> _selectedChildrenIds;

  @override
  void initState() {
    super.initState();
    final p = widget.initialParent;
    // Pré-remplissage automatique si on est en mode modification
    _nameController = TextEditingController(text: p?.name ?? '');
    _emailController = TextEditingController(text: p?.email ?? '');
    _phoneController = TextEditingController(text: p?.phone ?? '');
    _addressController = TextEditingController(text: p?.address ?? '');
    _selectedChildrenIds = List<String>.from(p?.childrenIds ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Valide le formulaire puis transmet les données au parent (page)
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'childrenIds': _selectedChildrenIds,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialParent != null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Nom complet ───────────────────────────────────
          _label('Nom complet'),
          const SizedBox(height: 6),
          _field(
            controller: _nameController,
            hint: 'Ex: M. Dupont Jean',
            icon: Icons.person_outline_rounded,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Le nom est requis' : null,
          ),

          const SizedBox(height: 18),

          // ── Email ─────────────────────────────────────────
          _label('Email'),
          const SizedBox(height: 6),
          _field(
            controller: _emailController,
            hint: 'Ex: jean.dupont@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'L\'email est requis';
              if (!v.contains('@') || !v.contains('.')) {
                return 'Email invalide';
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          // ── Téléphone ─────────────────────────────────────
          _label('Téléphone'),
          const SizedBox(height: 6),
          _field(
            controller: _phoneController,
            hint: 'Ex: +237 6 75 45 21 33',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Le téléphone est requis';
              }
              if (v.trim().length < 8) return 'Numéro trop court';
              return null;
            },
          ),

          const SizedBox(height: 18),

          // ── Adresse ───────────────────────────────────────
          _label('Adresse'),
          const SizedBox(height: 6),
          _field(
            controller: _addressController,
            hint: 'Ex: Yaoundé, Bastos',
            icon: Icons.location_on_outlined,
            maxLines: 2,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'L\'adresse est requise'
                : null,
          ),

          const SizedBox(height: 22),

          // ── Sélecteur d'enfants (association/désassociation) ─
          ParentChildrenSelector(
            initialSelectedIds: _selectedChildrenIds,
            onChanged: (ids) => setState(() => _selectedChildrenIds = ids),
          ),

          const SizedBox(height: 28),

          // ── Bouton de validation ──────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    const Color(0xFF2563EB).withOpacity(0.5),
                elevation: 2,
                shadowColor: const Color(0xFF2563EB).withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      isEditing
                          ? 'Enregistrer les modifications'
                          : 'Enregistrer le parent',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers d'UI ─────────────────────────────────────────────

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF475569),
        ),
      );

  Widget _field({
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
      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1E293B)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.poppins(fontSize: 13, color: const Color(0xFFCBD5E1)),
        prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
      ),
    );
  }
}
