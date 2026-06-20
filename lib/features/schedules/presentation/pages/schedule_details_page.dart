// ============================================================
// FICHIER : presentation/pages/schedule_details_page.dart
//
// RÔLE : Affiche tous les détails d'un créneau d'emploi du
// temps. Les données sont passées directement depuis la liste
// (pas de rappel Firestore nécessaire).
// ============================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_colors.dart';
import '../../domain/entities/schedule_entity.dart';
import 'edit_schedule_page.dart';

class ScheduleDetailsPage extends StatelessWidget {
  final ScheduleEntity schedule;

  const ScheduleDetailsPage({super.key, required this.schedule});

  // Couleur cohérente avec ScheduleCard
  Color _subjectColor(String subject) {
    final colors = [
      AppColors.blue,
      AppColors.green,
      AppColors.orange,
      AppColors.purple,
      const Color(0xFF06B6D4),
      const Color(0xFFEC4899),
      const Color(0xFF14B8A6),
    ];
    return colors[subject.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _subjectColor(schedule.subject);

    String createdDate;
    try {
      createdDate =
          DateFormat("d MMM yyyy 'à' HH:mm", 'fr_FR')
              .format(schedule.createdAt);
    } catch (_) {
      createdDate =
          DateFormat('dd/MM/yyyy HH:mm').format(schedule.createdAt);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Détails du créneau',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.blue),
            tooltip: 'Modifier',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditSchedulePage(schedule: schedule),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── EN-TÊTE COLORÉ ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.book_rounded,
                        color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.subject,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${schedule.className} · ${schedule.day}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── HORAIRE MIS EN VALEUR ────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: color.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule_rounded, color: color),
                  const SizedBox(width: 12),
                  Text(
                    '${schedule.startTime}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.arrow_forward_rounded,
                        color: color, size: 20),
                  ),
                  Text(
                    '${schedule.endTime}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── BLOC INFORMATIONS ────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Divider(height: 24, color: AppColors.border),
                  _InfoRow(
                    icon: Icons.class_rounded,
                    label: 'Classe',
                    value: schedule.className,
                  ),
                  _InfoRow(
                    icon: Icons.today_rounded,
                    label: 'Jour',
                    value: schedule.day,
                  ),
                  _InfoRow(
                    icon: Icons.book_rounded,
                    label: 'Matière',
                    value: schedule.subject,
                    color: color,
                  ),
                  _InfoRow(
                    icon: Icons.person_rounded,
                    label: 'Enseignant',
                    value: schedule.teacher,
                  ),
                  _InfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'Horaire',
                    value:
                        '${schedule.startTime} – ${schedule.endTime}',
                  ),
                  if (schedule.room.isNotEmpty)
                    _InfoRow(
                      icon: Icons.meeting_room_rounded,
                      label: 'Salle',
                      value: schedule.room,
                    ),
                  _InfoRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Ajouté le',
                    value: createdDate,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── BOUTON MODIFIER ──────────────────────────────
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EditSchedulePage(schedule: schedule),
                  ),
                ),
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text(
                  'Modifier ce créneau',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Ligne d'information (label + valeur) ────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.blue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: c.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: c),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
