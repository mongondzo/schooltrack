import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_card.dart';
import '../widgets/empty_attendance_widget.dart';
import 'add_attendance_page.dart';
import 'edit_attendance_page.dart';
import 'attendance_details_page.dart';

const _primaryColor = Color(0xFF2563EB);

/// -----------------------------------------------------------------------
/// AttendancePage
/// -----------------------------------------------------------------------
/// Page principale de la fonctionnalité Attendance.
///
/// C'est ICI que l'AttendanceBloc est créé et fourni (BlocProvider) à tout
/// l'arbre de widgets : la page elle-même, et toutes les pages poussées
/// par-dessus (Add/Edit/Details), qui réutilisent le même bloc.
///
/// `repository` doit être l'implémentation concrète de AttendanceRepository
/// fournie par la couche Data (AttendanceRepositoryImpl).
/// -----------------------------------------------------------------------
class AttendancePage extends StatelessWidget {
  final AttendanceRepository repository;

  const AttendancePage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceBloc(repository)..add(LoadAttendance()),
      child: const _AttendanceView(),
    );
  }
}

/// Vue interne : sépare la logique d'affichage de la création du bloc.
class _AttendanceView extends StatefulWidget {
  const _AttendanceView();

  @override
  State<_AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<_AttendanceView> {
  final _searchController = TextEditingController();
  String _query = '';

  /// Classe sélectionnée pour le filtre. "Toutes" = aucun filtre.
  String _selectedClasse = 'Toutes';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtre simple, en mémoire : recherche par élève + filtre par classe.
  List<AttendanceEntity> _filter(List<AttendanceEntity> list) {
    return list.where((a) {
      final matchesQuery = _query.trim().isEmpty ||
          a.studentName.toLowerCase().contains(_query.toLowerCase());
      final matchesClasse =
          _selectedClasse == 'Toutes' || a.classe == _selectedClasse;
      return matchesQuery && matchesClasse;
    }).toList();
  }

  void _goToAddPage(BuildContext context) {
    final bloc = context.read<AttendanceBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const AddAttendancePage(),
        ),
      ),
    );
  }

  void _goToEditPage(BuildContext context, AttendanceEntity attendance) {
    final bloc = context.read<AttendanceBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: EditAttendancePage(attendance: attendance),
        ),
      ),
    );
  }

  void _goToDetailsPage(BuildContext context, AttendanceEntity attendance) {
    final bloc = context.read<AttendanceBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: AttendanceDetailsPage(attendance: attendance),
        ),
      ),
    );
  }

  /// Change uniquement le statut d'une présence existante (action rapide
  /// depuis le menu de la carte), sans passer par le formulaire complet.
  void _markStatus(
    BuildContext context,
    AttendanceEntity attendance,
    AttendanceStatus status,
  ) {
    final updated = AttendanceEntity(
      id: attendance.id,
      studentId: attendance.studentId,
      studentName: attendance.studentName,
      classe: attendance.classe,
      date: attendance.date,
      status: status,
      createdAt: attendance.createdAt,
    );
    context.read<AttendanceBloc>().add(UpdateAttendance(updated));
  }

  void _confirmDelete(BuildContext context, AttendanceEntity attendance) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer la présence'),
        content: Text(
          'Voulez-vous vraiment supprimer la présence de "${attendance.studentName}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<AttendanceBloc>().add(DeleteAttendance(attendance.id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Présences'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: () => _goToAddPage(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Barre de recherche simple (filtrage local, en mémoire).
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Rechercher un élève...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state is AttendanceLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: _primaryColor),
                  );
                }

                if (state is AttendanceError) {
                  return Center(child: Text(state.message));
                }

                if (state is AttendanceLoaded) {
                  // Liste des classes disponibles, calculée à partir des
                  // présences chargées, pour construire le filtre.
                  final classes = <String>{
                    'Toutes',
                    ...state.attendanceList.map((a) => a.classe),
                  }.toList();

                  if (!classes.contains(_selectedClasse)) {
                    _selectedClasse = 'Toutes';
                  }

                  final filtered = _filter(state.attendanceList);

                  return Column(
                    children: [
                      // Filtre par classe (chips horizontaux défilants).
                      SizedBox(
                        height: 44,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: classes.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final classe = classes[index];
                            final isSelected = classe == _selectedClasse;
                            return ChoiceChip(
                              label: Text(classe),
                              selected: isSelected,
                              selectedColor: _primaryColor.withOpacity(0.15),
                              onSelected: (_) =>
                                  setState(() => _selectedClasse = classe),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: filtered.isEmpty
                            ? const EmptyAttendanceWidget()
                            : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final attendance = filtered[index];
                                  return AttendanceCard(
                                    attendance: attendance,
                                    onTap: () =>
                                        _goToDetailsPage(context, attendance),
                                    onEdit: () =>
                                        _goToEditPage(context, attendance),
                                    onDelete: () =>
                                        _confirmDelete(context, attendance),
                                    onMarkStatus: (status) =>
                                        _markStatus(context, attendance, status),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }

                // Cas de AttendanceInitial : rien à afficher pour l'instant.
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
