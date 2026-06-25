import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schooltrack/core/router/app_repositories.dart';
import 'package:schooltrack/features/classes/presentation/bloc/class_bloc.dart';
import 'package:schooltrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:schooltrack/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:schooltrack/features/schedules/data/datasources/schedule_remote_datasource.dart';
import 'package:schooltrack/features/schedules/data/repositories/schedule_repository_impl.dart';
import 'package:schooltrack/features/schedules/presentation/bloc/schedule_bloc.dart';

// ── Auth ───────────────────────────────────────────────────
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

        // ── 2. Students ────────────────────────────────────
        BlocProvider<ClassBloc>(
          create: (_) => ClassBloc(repository: classRepository),
        ),

        // ── 3. Emplois du temps ────────────────────────────────────
        BlocProvider<ScheduleBloc>(
          create: (_) => ScheduleBloc(
            repository: ScheduleRepositoryImpl(ScheduleRemoteDataSource()),
          ),
        ),

        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(repository: profileRepository),
        ),

        // ── 3. Classes ─────────────────────────────────────
        // BlocProvider<ClassBloc>(
        //   create: (context) => ClassBloc(
        //     authBloc: context.read<AuthBloc>(),
        //     repository: ClassRepositoryImpl(
        //       dataSource: ClassRemoteDataSourceImpl(),
        //     ),
        //   ),
        // ),

        // ── 4. Notes ───────────────────────────────────────
        // BlocProvider<GradeBloc>(
        //   create: (context) => GradeBloc(
        //     authBloc: context.read<AuthBloc>(),
        //     repository: GradeRepositoryImpl(
        //       dataSource: GradeRemoteDataSourceImpl(),
        //     ),
        //   ),
        // ),

        // ── 5. Présences ───────────────────────────────────
        // BlocProvider<AttendanceBloc>(
        //   create: (context) => AttendanceBloc(
        //     authBloc: context.read<AuthBloc>(),
        //     repository: AttendanceRepositoryImpl(
        //       dataSource: AttendanceRemoteDataSourceImpl(),
        //     ),
        //   ),
        // ),

        // ── 6. Notifications ───────────────────────────────
        // BlocProvider<NotificationBloc>(
        //   create: (context) => NotificationBloc(
        //     authBloc: context.read<AuthBloc>(),
        //     repository: NotificationRepositoryImpl(
        //       dataSource: NotificationRemoteDataSourceImpl(),
        //     ),
        //   ),
        // ),
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

          fontFamily: 'Roboto',

          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ), //  ferme ThemeData
        // Premier écran
        home: const SplashPage(), //  dans MaterialApp
      ),
    );
  }
}
