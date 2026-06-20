import 'package:flutter/material.dart';
import 'package:schooltrack/core/routes/app_repositories.dart';
import '../../../attendance/domain/entities/attendance_entity.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// AttendanceStatsCard
/// -----------------------------------------------------------------------
/// Carte à placer sur le Dashboard, qui affiche le nombre de présents,
/// d'absents et de retards parmi toutes les présences enregistrées.
///
/// Au chargement, elle récupère toutes les présences via
/// `attendanceRepository` et compte chaque statut.
/// -----------------------------------------------------------------------
class AttendanceStatsCard extends StatefulWidget {
  /// Action déclenchée quand on appuie sur la carte (ex: ouvrir AttendancePage).
  final VoidCallback? onTap;

  const AttendanceStatsCard({super.key, this.onTap});

  @override
  State<AttendanceStatsCard> createState() => _AttendanceStatsCardState();
}

class _AttendanceStatsCardState extends State<AttendanceStatsCard> {
  int? _presentCount;
  int? _absentCount;
  int? _lateCount;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    try {
      final list = await attendanceRepository.getAttendance();
      setState(() {
        _presentCount = list
            .where((a) => a.status == AttendanceStatus.present)
            .length;
        _absentCount = list
            .where((a) => a.status == AttendanceStatus.absent)
            .length;
        _lateCount = list
            .where((a) => a.status == AttendanceStatus.lateStatus)
            .length;
      });
    } catch (_) {
      setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.fact_check_outlined, color: _primaryColor, size: 18),
                SizedBox(width: 6),
                Text(
                  'Présences',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _hasError
                ? const Text('Impossible de charger les présences')
                : Row(
                    children: [
                      _StatItem(
                        label: 'Présents',
                        value: _presentCount,
                        color: Colors.green,
                      ),
                      _StatItem(
                        label: 'Absents',
                        value: _absentCount,
                        color: Colors.red,
                      ),
                      _StatItem(
                        label: 'Retards',
                        value: _lateCount,
                        color: Colors.orange,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

/// Petit widget privé affichant un nombre + un libellé, dans une couleur donnée.
class _StatItem extends StatelessWidget {
  final String label;
  final int? value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value == null ? '...' : '$value',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
