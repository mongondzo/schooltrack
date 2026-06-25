import 'package:flutter/material.dart';
import '../../domain/entities/attendance_entity.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// AttendanceForm
/// -----------------------------------------------------------------------
/// Formulaire réutilisable pour AJOUTER ou MODIFIER une présence.
///
/// - Pour un AJOUT : ne pas fournir les paramètres `initial...`.
/// - Pour une MODIFICATION : fournir les valeurs actuelles via
///   `initialStudentName`, `initialClasse`, `initialDate`, `initialStatus`.
///
/// `onSubmit` n'est appelé que si le formulaire est valide (élève et
/// classe renseignés). La date et le statut ont toujours une valeur
/// par défaut (aujourd'hui / présent).
/// -----------------------------------------------------------------------
class AttendanceForm extends StatefulWidget {
  final String? initialStudentName;
  final String? initialClasse;
  final DateTime? initialDate;
  final AttendanceStatus? initialStatus;
  final String submitButtonLabel;
  final void Function({
    required String studentName,
    required String classe,
    required DateTime date,
    required AttendanceStatus status,
  }) onSubmit;

  const AttendanceForm({
    super.key,
    this.initialStudentName,
    this.initialClasse,
    this.initialDate,
    this.initialStatus,
    required this.submitButtonLabel,
    required this.onSubmit,
  });

  @override
  State<AttendanceForm> createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  // La GlobalKey permet de valider et lire le formulaire depuis le code.
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _studentNameController;
  late final TextEditingController _classeController;
  late DateTime _selectedDate;
  late AttendanceStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _studentNameController =
        TextEditingController(text: widget.initialStudentName ?? '');
    _classeController = TextEditingController(text: widget.initialClasse ?? '');
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedStatus = widget.initialStatus ?? AttendanceStatus.present;
  }

  @override
  void dispose() {
    // Toujours libérer les controllers pour éviter les fuites de mémoire.
    _studentNameController.dispose();
    _classeController.dispose();
    super.dispose();
  }

  /// Formate une date en "jj/mm/aaaa" sans dépendance externe (intl).
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Ouvre le calendrier natif pour choisir la date de la présence.
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _handleSubmit() {
    // On déclenche la validation des champs texte (élève, classe).
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        studentName: _studentNameController.text.trim(),
        classe: _classeController.text.trim(),
        date: _selectedDate,
        status: _selectedStatus,
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

          // Sélecteur de date : on affiche la date choisie dans un champ
          // qui ouvre le calendrier natif au clic.
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              child: Text(_formatDate(_selectedDate)),
            ),
          ),
          const SizedBox(height: 16),

          // Sélecteur de statut : 3 boutons exclusifs (Material 3).
          Text('Statut', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<AttendanceStatus>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: AttendanceStatus.present,
                label: Text('Présent'),
              ),
              ButtonSegment(
                value: AttendanceStatus.absent,
                label: Text('Absent'),
              ),
              ButtonSegment(
                value: AttendanceStatus.lateStatus,
                label: Text('Retard'),
              ),
            ],
            selected: {_selectedStatus},
            onSelectionChanged: (newSelection) {
              setState(() => _selectedStatus = newSelection.first);
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
