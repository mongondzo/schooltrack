import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schooltrack/core/routes/app_router.dart';
import 'package:schooltrack/features/auth/data/data/auth_remote_datasource.dart';
import 'package:schooltrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:schooltrack/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:schooltrack/features/auth/domain/usecases/sign_out.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_event.dart';
import 'package:schooltrack/features/classes/data/datasources/class_firestore_datasource.dart';
import 'package:schooltrack/features/classes/data/repositories/class_repository_impl.dart';
import 'package:schooltrack/features/classes/presentation/bloc/class_bloc.dart';
import 'package:schooltrack/features/dashboard/data/data/dashboard_remote_datasource.dart';
import 'package:schooltrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:schooltrack/features/dashboard/domain/usecases/get_dashboard_stats.dart';
import 'package:schooltrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';

void main() async {
  // Nécessaire avant d'utiliser Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase (doit être fait avant tout)
  await Firebase.initializeApp();

  //initialise la date
  await initializeDateFormatting('fr_FR', null);

  runApp(const SchoolTrackApp());
}

class SchoolTrackApp extends StatelessWidget {
  const SchoolTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    //instance data ressource
    final authRemoteDatasource = AuthRemoteDatasourceImpl();
    final authRepository = AuthRepositoryImpl(
      remoteDatasource: authRemoteDatasource,
    );

    //instance signInWithGoogle
    final signInWithGoogle = SignInWithGoogle(authRepository);
    final signOut = SignOut(authRepository);

    //instane Dashboard
    final dashboardRemoteDatasource = DashboardRemoteDatasourceImpl();
    final dashboardRepository = DashboardRepositoryImpl(
      remoteDatasource: dashboardRemoteDatasource,
    );
    final getDashboardStats = GetDashboardStats(dashboardRepository);

    //instance classe
    final classRepository = ClassRepositoryImpl(
      dataSource: ClassFirestoreDataSource(),
    );

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

        // fournir pour la class :
        BlocProvider<ClassBloc>(
          create: (_) => ClassBloc(repository: classRepository),
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

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr', 'FR')],

        routerConfig: AppRouter.router,
      ),
    );
  }
}
