part of 'dashboard_bloc.dart';

abstract class DashboardState {}

// État initial du dashboard
class DashboardInitial extends DashboardState {}

// État : chargement des données en cours
class DashboardLoading extends DashboardState {}

// État : données chargées avec succès
class DashboardLoaded extends DashboardState {
  final DashboardStatsEntity stats; // Les statistiques récupérées

  DashboardLoaded(this.stats);
}

// État : erreur lors du chargement
class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
