import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schooltrack/features/auth/presentation/pages/profile_page.dart';
import 'package:schooltrack/features/auth/presentation/widgets/google_sign_in_button.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<AuthBloc, AuthState>(
      // ── listener : réagit aux changements sans reconstruire ─
      // Utilisé pour la navigation et les SnackBars d'erreur.
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Connexion réussie → on redirige selon le rôle
          _navigateByRole(context, state);
        }

        if (state is AuthError) {
          // Erreur → SnackBar en bas de l'écran
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(12),
            ),
          );
        }
      },

      // ── builder : reconstruit l'UI selon l'état ────────────
      builder: (context, state) {
        // Est-ce qu'une opération est en cours ?
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFF),
          body: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Column(
                children: [
                  // Partie haute : illustration avec le header
                  _buildHeader(size),

                  // Partie basse : formulaire de connexion avec google
                  Expanded(child: _buildLoginForm(context)),

                  // ── Mentions légales
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: const _FooterSection(),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Redirige vers le profil après connexion ─────────────────
  void _navigateByRole(BuildContext context, AuthAuthenticated state) {
    // Pour simplifier, tout le monde va vers ProfilePage
    // Vous pourrez ajouter la logique de rôles plus tard
    final destination = const ProfilePage();

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }
}

// WIDGET PRIVÉ : Pied de page avec mentions légales
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Text(
      'En vous connectant, vous acceptez nos\nConditions d\'utilisation et notre Politique de confidentialité',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11, color: Colors.grey.shade400, height: 1.6),
    );
  }
}

// Widget du header avec fond bleu dégradé
Widget _buildHeader(Size size) {
  return Container(
    height: size.height * 0.42,
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)],
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    ),
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            //logo application
            child: Image(
              image: AssetImage("assets/images/schooltrack.png"),
              width: 30,
              height: 40,
            ),
          ),

          const SizedBox(height: 20),

          // Nom de l'app
          Text(
            'SchoolTrack',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'La gestion scolaire simplifiée',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    ),
  );
}

// Widget du formulaire de connexion
Widget _buildLoginForm(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Text(
          'Bienvenue',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Connectez-vous à votre compte SchoolTrack',
          style: TextStyle(fontSize: 14, color: const Color(0xFF64748B)),
        ),

        const SizedBox(height: 40),

        // Indicateur de rôle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Color(0xFF2563EB),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Connectez-vous avec votre compte Google',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF1E40AF),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Bouton Google Sign In
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return GoogleSignInButton(
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () {
                      // l'événement de la connexion Google
                      context.read<AuthBloc>().add(const SignInWithGoogle());
                    },
            );
          },
        ),
      ],
    ),
  );
}
