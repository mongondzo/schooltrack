import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// NotificationForm
/// -----------------------------------------------------------------------
/// Formulaire réutilisable pour CRÉER ou MODIFIER une notification.
///
/// - Pour une CRÉATION : ne pas fournir les paramètres `initial...`.
/// - Pour une MODIFICATION : fournir les valeurs actuelles via
///   `initialTitle`, `initialMessage`, `initialTargetRole`.
///
/// `onSubmit` n'est appelé que si le titre et le message sont renseignés.
/// -----------------------------------------------------------------------
class NotificationForm extends StatefulWidget {
  final String? initialTitle;
  final String? initialMessage;
  final NotificationTargetRole? initialTargetRole;
  final String submitButtonLabel;
  final void Function({
    required String title,
    required String message,
    required NotificationTargetRole targetRole,
  }) onSubmit;

  const NotificationForm({
    super.key,
    this.initialTitle,
    this.initialMessage,
    this.initialTargetRole,
    required this.submitButtonLabel,
    required this.onSubmit,
  });

  @override
  State<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  // La GlobalKey permet de valider et lire le formulaire depuis le code.
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _messageController;
  late NotificationTargetRole _selectedTargetRole;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _messageController =
        TextEditingController(text: widget.initialMessage ?? '');
    _selectedTargetRole =
        widget.initialTargetRole ?? NotificationTargetRole.all;
  }

  @override
  void dispose() {
    // Toujours libérer les controllers pour éviter les fuites de mémoire.
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    // On déclenche la validation des champs texte.
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        targetRole: _selectedTargetRole,
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
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Titre',
              hintText: 'Ex: Réunion parents',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le titre est obligatoire';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Message',
              hintText: 'Écris le contenu de la notification...',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Le message est obligatoire';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Sélecteur de destinataire : 3 boutons exclusifs (Material 3).
          Text('Destinataire', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<NotificationTargetRole>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: NotificationTargetRole.admin,
                label: Text('Admin'),
              ),
              ButtonSegment(
                value: NotificationTargetRole.parent,
                label: Text('Parents'),
              ),
              ButtonSegment(
                value: NotificationTargetRole.all,
                label: Text('Tous'),
              ),
            ],
            selected: {_selectedTargetRole},
            onSelectionChanged: (newSelection) {
              setState(() => _selectedTargetRole = newSelection.first);
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
