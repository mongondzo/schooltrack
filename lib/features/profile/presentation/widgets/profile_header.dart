// ════════════════════════════════════════════════════════════════
// WIDGET : ProfileHeader
// Rôle   : Partie haute de ProfilePage.
//          Affiche la photo de profil (ou avatar avec initiales),
//          le nom complet et l'adresse email.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schooltrack/features/profile/domain/entities/profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
      ),
      child: Column(
        children: [
          // ── Photo ou avatar ────────────────────────────────
          _buildAvatar(),

          const SizedBox(height: 16),

          // ── Nom ───────────────────────────────────────────
          Text(
            profile.name,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // ── Email ─────────────────────────────────────────
          Text(
            profile.email,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // ── Badge rôle ────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Text(
              profile.roleLabel,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        // Cercle principal (photo ou initiales)
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            color: Colors.white.withOpacity(0.2),
          ),
          child: ClipOval(
            child: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                ? Image.network(
                    profile.photoUrl!,
                    fit: BoxFit.cover,
                    // En cas d'erreur de chargement → on affiche les initiales
                    errorBuilder: (_, __, ___) => _initialsWidget(),
                  )
                : _initialsWidget(),
          ),
        ),

        // Petit badge vert "en ligne" en bas à droite
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // Avatar de secours avec les initiales du nom
  Widget _initialsWidget() {
    return Container(
      color: Colors.white.withOpacity(0.3),
      child: Center(
        child: Text(
          profile.initials,
          style: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
