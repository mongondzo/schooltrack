// ════════════════════════════════════════════════════════════════
// WIDGET : ParentCard (parent_card.dart)
// Rôle   : Carte affichée pour chaque parent dans ParentsPage.
//          Affiche nom, email, téléphone, nombre d'enfants.
//          Propose un menu Modifier / Supprimer.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schooltrack/features/parents/domain/entities/parent_entity.dart';

class ParentCard extends StatelessWidget {
  final ParentEntity parent;
  final VoidCallback onTap;     // Tap → page de détails
  final VoidCallback onEdit;    // Bouton modifier
  final VoidCallback onDelete;  // Bouton supprimer

  const ParentCard({
    super.key,
    required this.parent,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  // Couleur stable de l'avatar selon la première lettre du nom
  Color _avatarColor() {
    const colors = [
      Color(0xFF2563EB),
      Color(0xFF10B981),
      Color(0xFF7C3AED),
      Color(0xFFD97706),
      Color(0xFFDC2626),
      Color(0xFF0891B2),
    ];
    if (parent.name.isEmpty) return colors[0];
    return colors[parent.name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _avatarColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Avatar (initiales) ───────────────────────────
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 1.5),
              ),
              child: Center(
                child: Text(
                  parent.initials,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Informations principales ──────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parent.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  Row(
                    children: [
                      const Icon(Icons.email_outlined,
                          size: 12, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          parent.email,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  Row(
                    children: [
                      const Icon(Icons.phone_outlined,
                          size: 12, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text(
                        parent.phone,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Badge nombre d'enfants
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      parent.childrenCount == 0
                          ? 'Aucun enfant associé'
                          : '${parent.childrenCount} enfant${parent.childrenCount > 1 ? 's' : ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Menu d'actions ─────────────────────────────────
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded,
                  color: Color(0xFFCBD5E1), size: 22),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit_rounded,
                          color: Color(0xFF2563EB), size: 18),
                      const SizedBox(width: 10),
                      Text('Modifier',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: const Color(0xFF2563EB))),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_rounded,
                          color: Colors.red.shade600, size: 18),
                      const SizedBox(width: 10),
                      Text('Supprimer',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: Colors.red.shade600)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
