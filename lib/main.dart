import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/core/router/app_router.dart';
import 'package:schooltrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:schooltrack/features/auth/data/services/firebase_auth_service.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schooltrack/features/auth/presentation/bloc/splash_page.dart';
import 'package:schooltrack/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  // Widget build(BuildContext context) {
  //   final authRepositoryImpl = AuthRepositoryImpl(FirebaseAuthService());
  //   return MultiBlocProvider(
  //     providers: [BlocProvider(create: (_) => AuthBloc(authRepositoryImpl))],
  //     child: MaterialApp.router(
  //       title: "schoolTrack",
  //       theme: ThemeData(
  //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       ),
  //       routerConfig: appRouter,
  //     ),
  //   );
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schooltrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Nunito',
      ),
      home: const SplashPage(),
    );
  }
}
