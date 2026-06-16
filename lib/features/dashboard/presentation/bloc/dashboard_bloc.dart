import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:schooltrack/features/dashboard/domain/usecases/get_dashboard_stats.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

// DashboardBloc : gère le chargement des statistiques du dashboard
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStats getDashboardStats;

  DashboardBloc({required this.getDashboardStats}) : super(DashboardInitial()) {
    on<DashboardStatsRequested>(_onStatsRequested);
  }

  // Handler : charge les statistiques depuis Firebase
  Future<void> _onStatsRequested(
    DashboardStatsRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading()); // Affiche le skeleton loader

    try {
      final DashboardStatsEntity stats = await getDashboardStats();
      emit(DashboardLoaded(stats)); // Affiche les données
    } catch (e) {
      emit(DashboardError(e.toString())); // Affiche l'erreur
    }
  }
}
