// ============================================================
// FICHIER : presentation/widgets/schedule_form.dart
//
// RÔLE : Formulaire réutilisable pour AJOUTER et MODIFIER
// un créneau d'emploi du temps.
//
// Utilisé dans AddSchedulePage (champs vides) et
// EditSchedulePage (champs pré-remplis via initialValues).
//
// Validations :
//   - Tous les champs obligatoires sauf "Salle"
//   - L'heure de fin doit être différente de l'heure de début
// ============================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';

// Valeurs initiales pour le mode édition
class ScheduleFormValues {
  final String classId;
  final String className;
  final String day;
  final String subject;
  final String teacher;
  final String startTime;
  final String endTime;
  final String room;

  const ScheduleFormValues({
    required this.classId,
    required this.className,
    required this.day,
    required this.subject,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    required this.room,
  });
}

class ScheduleForm extends StatefulWidget {
  final ScheduleFormValues? initialValues;
  final void Function({
    required String classId,
    required String className,
    required String day,
    required String subject,
    required String teacher,
    required String startTime,
    required String endTime,
    required String room,
  }) onSubmit;
  final String submitLabel;

  const ScheduleForm({
    super.key,
    this.initialValues,
    required this.onSubmit,
    this.submitLabel = 'Enregistrer',
  });

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _classNameCtrl;
  late final TextEditingController _classIdCtrl;
  late final TextEditingController _subjectCtrl;
  late final TextEditingController _teacherCtrl;
  late final TextEditingController _roomCtrl;

  String? _selectedDay;
  String _startTime = '';
  String _endTime = '';

  // Jours disponibles dans l'ordre de la semaine
  static const List<String> _days = [
    'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi',
  ];

  @override
  void initState() {
    super.initState();
    final v = widget.initialValues;
    _classNameCtrl = TextEditingController(text: v?.className ?? '');
    _classIdCtrl   = TextEditingController(text: v?.classId ?? '');
    _subjectCtrl   = TextEditingController(text: v?.subject ?? '');
    _teacherCtrl   = TextEditingController(text: v?.teacher ?? '');
    _roomCtrl      = TextEditingController(text: v?.room ?? '');
    _selectedDay   = v?.day;
    _startTime     = v?.startTime ?? '';
    _endTime       = v?.endTime ?? '';
  }

  @override
  void dispose() {
    _classNameCtrl.dispose();
    _classIdCtrl.dispose();
    _subjectCtrl.dispose();
    _teacherCtrl.dispose();
    _roomCtrl.dispose();
    super.dispose();
  }

  // Ouvre le sélecteur d'heure Flutter et retourne "HH:mm"
  Future<String?> _pickTime(BuildContext context, String current) async {
    // Parse l'heure actuelle si déjà saisie
    TimeOfDay initial = TimeOfDay.now();
    if (current.isNotEmpty) {
      final parts = current.split(':');
      if (parts.length == 2) {
        initial = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? TimeOfDay.now().hour,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        // Force le format 24h
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked == null) return null;
    // Format HH:mm avec zéro initial
    final h = picked.hour.toString().padLeft(2, '0');
    final m = picked.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  InputDecoration _deco(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.blue, size: 20),
      filled: true,
      fillColor: AppColors.fieldBg,
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
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
      );

  void _submit() {
    // Valide d'abord le formulaire Flutter
    if (!_formKey.currentState!.validate()) return;

    // Vérifie que le jour est sélectionné
    if (_selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un jour'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    // Vérifie que les heures sont saisies
    if (_startTime.isEmpty || _endTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner les heures de début et de fin'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    // Vérifie que l'heure de fin est après l'heure de début
    if (_endTime.compareTo(_startTime) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('L\'heure de fin doit être après l\'heure de début'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    widget.onSubmit(
      classId: _classIdCtrl.text.trim(),
      className: _classNameCtrl.text.trim(),
      day: _selectedDay!,
      subject: _subjectCtrl.text.trim(),
      teacher: _teacherCtrl.text.trim(),
      startTime: _startTime,
      endTime: _endTime,
      room: _roomCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── SECTION CLASSE ─────────────────────────────────
          _sectionLabel('CLASSE'),

          TextFormField(
            controller: _classNameCtrl,
            decoration: _deco('Nom de la classe', Icons.class_rounded,
                hint: 'Ex : 6ème A'),
            textCapitalization: TextCapitalization.words,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Le nom de la classe est obligatoire'
                : null,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _classIdCtrl,
            decoration: _deco(
                'ID de la classe (optionnel)', Icons.tag_rounded,
                hint: 'Ex : classe_001'),
          ),
          const SizedBox(height: 20),

          // ── SECTION JOUR ────────────────────────────────────
          _sectionLabel('JOUR DE LA SEMAINE'),

          // Sélection du jour par chips cliquables
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _days.map((day) {
              final isSelected = _selectedDay == day;
              return ChoiceChip(
                label: Text(day),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedDay = day),
                selectedColor: AppColors.blue,
                backgroundColor: AppColors.fieldBg,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondary,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.blue : AppColors.border,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // ── SECTION HORAIRE ─────────────────────────────────
          _sectionLabel('HORAIRE'),

          Row(
            children: [
              // Heure de début
              Expanded(
                child: _TimeButton(
                  label: 'Début',
                  time: _startTime,
                  icon: Icons.schedule_rounded,
                  onTap: () async {
                    final t = await _pickTime(context, _startTime);
                    if (t != null) setState(() => _startTime = t);
                  },
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded,
                  color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 12),
              // Heure de fin
              Expanded(
                child: _TimeButton(
                  label: 'Fin',
                  time: _endTime,
                  icon: Icons.schedule_rounded,
                  onTap: () async {
                    final t = await _pickTime(context, _endTime);
                    if (t != null) setState(() => _endTime = t);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── SECTION COURS ───────────────────────────────────
          _sectionLabel('INFORMATIONS DU COURS'),

          TextFormField(
            controller: _subjectCtrl,
            decoration: _deco('Matière', Icons.book_rounded,
                hint: 'Ex : Mathématiques'),
            textCapitalization: TextCapitalization.sentences,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'La matière est obligatoire'
                : null,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _teacherCtrl,
            decoration: _deco('Enseignant', Icons.person_rounded,
                hint: 'Ex : M. Dupont'),
            textCapitalization: TextCapitalization.words,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'L\'enseignant est obligatoire'
                : null,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _roomCtrl,
            decoration: _deco('Salle (optionnelle)',
                Icons.meeting_room_rounded,
                hint: 'Ex : Salle 12'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 28),

          // ── BOUTON VALIDER ──────────────────────────────────
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _submit,
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

// ── Widget interne : bouton de sélection d'heure ──────────
class _TimeButton extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final VoidCallback onTap;

  const _TimeButton({
    required this.label,
    required this.time,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasTime = time.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: hasTime
              ? AppColors.blue.withOpacity(0.08)
              : AppColors.fieldBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasTime ? AppColors.blue : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color:
                    hasTime ? AppColors.blue : AppColors.textSecondary),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary)),
                Text(
                  hasTime ? time : '--:--',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: hasTime
                        ? AppColors.blue
                        : AppColors.textSecondary,
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
