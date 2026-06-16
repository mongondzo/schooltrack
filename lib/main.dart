import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/core/routes/app_router.dart';
import 'package:schooltrack/features/auth/data/data/auth_remote_datasource.dart';
import 'package:schooltrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:schooltrack/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:schooltrack/features/auth/domain/usecases/sign_out.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_event.dart';
import 'package:schooltrack/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:schooltrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:schooltrack/features/dashboard/domain/usecases/get_dashboard_stats.dart';
import 'package:schooltrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';

void main() async {
  // Nécessaire avant d'utiliser Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase (doit être fait avant tout)
  await Firebase.initializeApp();

  runApp(const SchoolTrackApp());
}

class SchoolTrackApp extends StatelessWidget {
  const SchoolTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // On instancie toutes les dépendances ici (injection manuelle)
    // Pour un projet plus grand, on utiliserait get_it ou injectable

    final authRemoteDatasource = AuthRemoteDatasourceImpl();
    final authRepository = AuthRepositoryImpl(
      remoteDatasource: authRemoteDatasource,
    );
    final signInWithGoogle = SignInWithGoogle(authRepository);
    final signOut = SignOut(authRepository);

    final dashboardRemoteDatasource = DashboardRemoteDatasourceImpl();
    final dashboardRepository = DashboardRepositoryImpl(
      remoteDatasource: dashboardRemoteDatasource,
    );
    final getDashboardStats = GetDashboardStats(dashboardRepository);

    return MultiBlocProvider(
      providers: [
        // Fournit AuthBloc à toute l'application
        BlocProvider<AuthBloc>(
          create: (_) =>
              AuthBloc(signInWithGoogle: signInWithGoogle, signOut: signOut)
                ..add(
                  AuthCheckRequested(),
                ), // Vérifie si l'utilisateur est déjà connecté
        ),
        // Fournit DashboardBloc à toute l'application
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc(getDashboardStats: getDashboardStats),
        ),
      ],
      child: MaterialApp.router(
        title: 'SchoolTrack',
        debugShowCheckedModeBanner: false,

        // Thème Material 3 avec couleur principale #2563EB
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Nunito',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        ),

        routerConfig: AppRouter.router,
      ),
    );
  }
}
