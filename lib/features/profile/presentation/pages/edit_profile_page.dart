// ════════════════════════════════════════════════════════════════
// PAGE : EditProfilePage
// Rôle  : Formulaire de modification du profil.
//         Pré-rempli avec les infos existantes.
//         Envoie UpdateProfile au Bloc si le formulaire est valide.
// ════════════════════════════════════════════════════════════════

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schooltrack/features/profile/domain/entities/profile_entity.dart';
import 'package:schooltrack/features/profile/presentation/bloc/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _isInitialized = false;

  // Pré-remplit les contrôleurs depuis le profil chargé dans le Bloc
  void _initControllers(ProfileEntity profile) {
    if (_isInitialized) return;
    _nameController = TextEditingController(text: profile.name);
    _phoneController = TextEditingController(text: profile.phone);
    _isInitialized = true;
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _nameController.dispose();
      _phoneController.dispose();
    }
    super.dispose();
  }

  void _submit(ProfileEntity profile) {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Envoi de l'Event de mise à jour au Bloc
    context.read<ProfileBloc>().add(
          UpdateProfile(
            uid: uid,
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
          ),
        );
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
          'Modifier le profil',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        elevation: 0,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        // listener : réagit aux states sans reconstruire
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            // Succès → on revient en arrière
            context.pop();
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message,
                    style: GoogleFonts.poppins(fontSize: 13)),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        // builder : construit l'UI selon l'état
        builder: (context, state) {
          // On récupère le profil depuis l'état courant
          ProfileEntity? profile;
          if (state is ProfileLoaded) profile = state.profile;
          if (state is ProfileUpdateSuccess) profile = state.profile;
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            );
          }

          if (profile == null) {
            return const Center(child: Text('Profil non disponible'));
          }

          // Initialise les contrôleurs une seule fois avec les données
          _initControllers(profile);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ── Photo (non modifiable ici, indication) ────
                _buildPhotoSection(profile),

                const SizedBox(height: 28),

                // ── Formulaire ────────────────────────────────
                _buildForm(profile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoSection(ProfileEntity profile) {
    return Center(
      child: Stack(
        children: [
          // Photo ou initiales
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: const Color(0xFF2563EB).withOpacity(0.3), width: 2),
              color: const Color(0xFFEFF6FF),
            ),
            child: ClipOval(
              child: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                  ? Image.network(profile.photoUrl!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _initialsWidget(profile))
                  : _initialsWidget(profile),
            ),
          ),
          // Petite icône appareil photo (indicatif — upload photo hors scope)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt_rounded,
                  color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _initialsWidget(ProfileEntity profile) {
    return Container(
      color: const Color(0xFFEFF6FF),
      child: Center(
        child: Text(
          profile.initials,
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2563EB),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(ProfileEntity profile) {
    return Container(
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Email (lecture seule) ──────────────────────
            _readOnlyField(
              label: 'Email',
              value: profile.email,
              icon: Icons.email_outlined,
              note: 'L\'email Google ne peut pas être modifié',
            ),

            const SizedBox(height: 20),

            // ── Nom complet ────────────────────────────────
            _fieldLabel('Nom complet'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameController,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: const Color(0xFF1E293B)),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Le nom est requis' : null,
              decoration: _inputDeco('Ex: Jean Dupont', Icons.person_outlined),
            ),

            const SizedBox(height: 20),

            // ── Téléphone ─────────────────────────────────
            _fieldLabel('Téléphone'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: const Color(0xFF1E293B)),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Le téléphone est requis';
                if (v.trim().length < 8) return 'Numéro trop court';
                return null;
              },
              decoration: _inputDeco(
                  'Ex: +237 6 75 45 21 33', Icons.phone_outlined),
            ),

            const SizedBox(height: 28),

            // ── Bouton Enregistrer ─────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _submit(profile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: const Color(0xFF2563EB).withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Enregistrer les modifications',
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Champ non modifiable avec une note explicative
  Widget _readOnlyField({
    required String label,
    required String value,
    required IconData icon,
    String? note,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFCBD5E1), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: const Color(0xFF94A3B8))),
              ),
              const Icon(Icons.lock_outline_rounded,
                  color: Color(0xFFCBD5E1), size: 16),
            ],
          ),
        ),
        if (note != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(note,
                style: GoogleFonts.poppins(
                    fontSize: 10, color: const Color(0xFFCBD5E1))),
          ),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF475569),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          GoogleFonts.poppins(fontSize: 13, color: const Color(0xFFCBD5E1)),
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }
}
