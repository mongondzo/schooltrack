// ════════════════════════════════════════════════════════════════
// WIDGET : ProfileInfoCard
// Rôle   : Carte blanche affichant les informations secondaires
//          du profil : téléphone, rôle et date d'inscription.
//          Chaque ligne est construite par _InfoRow (widget interne).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:schooltrack/features/profile/domain/entities/profile_entity.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Téléphone ──────────────────────────────────────
          _InfoRow(
            icon: Icons.phone_outlined,
            iconColor: const Color(0xFF2563EB),
            label: 'Téléphone',
            value: profile.phone.isNotEmpty ? profile.phone : 'Non renseigné',
            isFirst: true,
          ),
          _divider(),

          // ── Rôle ───────────────────────────────────────────
          _InfoRow(
            icon: Icons.admin_panel_settings_outlined,
            iconColor: const Color(0xFF7C3AED),
            label: 'Rôle',
            value: profile.roleLabel,
          ),
          _divider(),

          // ── Date d'inscription ─────────────────────────────
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF10B981),
            label: 'Membre depuis',
            value: DateFormat('dd MMMM yyyy', 'fr').format(profile.createdAt),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 60, endIndent: 16);
}

// ── Widget interne : une ligne d'information ─────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isFirst;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isFirst ? 20 : 14,
        bottom: isLast ? 20 : 14,
      ),
      child: Row(
        children: [
          // Icône dans un fond coloré léger
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),

          const SizedBox(width: 14),

          // Label + valeur empilés verticalement
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
