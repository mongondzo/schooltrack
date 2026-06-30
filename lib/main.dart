import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schooltrack/core/router/app_repositories.dart';
import 'package:schooltrack/features/classes/presentation/bloc/class_bloc.dart';
import 'package:schooltrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:schooltrack/features/parents/presentation/bloc/parent_bloc.dart';
import 'package:schooltrack/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:schooltrack/features/schedules/data/datasources/schedule_remote_datasource.dart';
import 'package:schooltrack/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:schooltrack/features/schedules/presentation/bloc/schedule_bloc.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await initializeDateFormatting('fr_FR', null);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SchoolTrackApp());
}

class SchoolTrackApp extends StatelessWidget {
  const SchoolTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ── 1. Auth ────────────────────────────────────────
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(repository: AuthRepositoryImpl()),
        ),

        // Fournit DashboardBloc à toute l'application
        BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc(getDashboardStats: getDashboardStats),
        ),

        // ── 2. Students
        BlocProvider<ClassBloc>(
          create: (_) => ClassBloc(repository: classRepository),
        ),

        // ── 3. Emplois du temps
        BlocProvider<ScheduleBloc>(
          create: (_) => ScheduleBloc(
            repository: ScheduleRepositoryImpl(ScheduleRemoteDataSource()),
          ),
        ),

        // ── 4. profil
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(repository: profileRepository),
        ),

        BlocProvider<ParentBloc>(
          create: (_) => ParentBloc(repository: parentRepository),
        ),
      ],

      child: MaterialApp(
        title: 'SchoolTrack',
        debugShowCheckedModeBanner: false,

        // ── Thème Material 3 ──────────────────────────────
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
            brightness: Brightness.light,
          ),

          // Police de toute l'application
          textTheme: GoogleFonts.poppinsTextTheme(),
          primaryTextTheme: GoogleFonts.poppinsTextTheme(),

          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ), //  ferme ThemeData
        // Premier écran
        home: const SplashPage(), //  dans MaterialApp
      ),
    );
  }
}
