import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/attendance_entity.dart';
import '../bloc/attendance_bloc.dart';
import 'edit_attendance_page.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// AttendanceDetailsPage
/// -----------------------------------------------------------------------
/// Page affichant tous les détails d'une présence.
/// -----------------------------------------------------------------------
class AttendanceDetailsPage extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceDetailsPage({super.key, required this.attendance});

  /// Formate une date en "jj/mm/aaaa" sans dépendance externe (intl).
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Color get _statusColor {
    switch (attendance.status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.lateStatus:
        return Colors.orange;
    }
  }

  IconData get _statusIcon {
    switch (attendance.status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.absent:
        return Icons.cancel;
      case AttendanceStatus.lateStatus:
        return Icons.watch_later;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AttendanceBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la présence'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: bloc,
                    child: EditAttendancePage(attendance: attendance),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: _statusColor.withOpacity(0.1),
              child: Icon(_statusIcon, size: 40, color: _statusColor),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              attendance.studentName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          _InfoTile(label: 'Classe', value: attendance.classe),
          _InfoTile(label: 'Date', value: _formatDate(attendance.date)),
          _InfoTile(label: 'Statut', value: attendance.status.label),
          _InfoTile(
            label: 'Date de création',
            value: _formatDate(attendance.createdAt),
          ),
        ],
      ),
    );
  }
}

/// Petit widget privé pour afficher une ligne "label : valeur".
class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
