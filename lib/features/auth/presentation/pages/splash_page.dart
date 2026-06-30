import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/core/services/connectivity_service.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schooltrack/features/auth/presentation/pages/login_page.dart';
import 'package:schooltrack/features/auth/presentation/pages/no_internet_page.dart';
import 'package:schooltrack/features/dashboard/presentation/pages/dashboard_page.dart';

class SplashPage extends StatefulWidget {
  // Nom de route pour la navigation nommée
  static const String routeName = '/splash';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  // ── Animation du logo ─────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startChecks();
  }

  // ── Configure l'animation d'apparition du logo ───────────
  void _setupAnimation() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
  }

  // ──────────────────────────────────────────────────────────
  // _startChecks() — Lance les vérifications au démarrage
  //
  // On attend un minimum de 1.5 secondes pour que l'animation
  // soit visible, puis on navigue selon la situation.
  // ──────────────────────────────────────────────────────────
  Future<void> _startChecks() async {
    // Attente minimum pour l'animation du splash
    await Future.delayed(const Duration(milliseconds: 1500));

    // Vérifie si le widget est encore monté (pas détruit)
    if (!mounted) return;

    // ── Vérification 1 : Internet ─────────────────────────
    final hasInternet = await _connectivityService.hasInternet();

    if (!mounted) return;

    if (!hasInternet) {
      // Pas de connexion → page d'erreur réseau
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NoInternetPage()),
      );
      return;
    }

    // ── Vérification 2 : Session utilisateur ──────────────
    // On déclenche la vérification via le BLoC
    // Le BLoC va émettre AuthAuthenticated ou AuthUnauthenticated
    context.read<AuthBloc>().add(const CheckAuthStatus());

    // La navigation sera gérée par BlocListener (voir build())
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // BlocListener réagit aux changements d'état du BLoC
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _navigateByRole(context, state);
        } else if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        } else if (state is AuthError) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
        // AuthLoading : on ne fait rien, le spinner tourne déjà
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E40AF), // Bleu foncé
                Color(0xFF2563EB), // Bleu principal
                Color(0xFF3B82F6), // Bleu clair
              ],
            ),
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(scale: _scaleAnimation, child: child),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icône de l'application
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: // Logo Google
                    Image(
                      image: AssetImage("assets/images/schooltrack.png"),
                      width: 30,
                      height: 40,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Nom de l'application
                  Text(
                    'BolandiApp',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'La gestion scolaire simplifiée',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 60),

                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                      strokeWidth: 3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Chargement...',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // _navigateByRole() — Redirige selon le rôle de l'utilisateur
  // admin  → DashboardPage (gestion complète)
  void _navigateByRole(BuildContext context, AuthAuthenticated state) {
    // Pour simplifier, on redirige tout le monde vers le dashboard
    // Vous pourrez ajouter la logique de rôles plus tard
    final destination = DashboardPage();

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }
}
