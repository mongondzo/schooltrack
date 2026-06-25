// ════════════════════════════════════════════════════════════════
// PAGE : ProfilePage
// Rôle  : Écran principal du profil utilisateur.
//         Affiche les infos, propose de modifier et de se déconnecter.
//         Écoute le ProfileBloc pour réagir aux changements d'état.
// ════════════════════════════════════════════════════════════════

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schooltrack/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:schooltrack/features/profile/presentation/widgets/logout_button.dart';
import 'package:schooltrack/features/profile/presentation/widgets/profile_header.dart';
import 'package:schooltrack/features/profile/presentation/widgets/profile_info_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Au démarrage, on demande au Bloc de charger le profil
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      context.read<ProfileBloc>().add(LoadProfile(uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      // BlocListener réagit aux états SANS reconstruire le widget
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // Déconnexion réussie → retour à la page login
          if (state is ProfileLoggedOut) {
            context.go('/login');
          }

          // Mise à jour réussie → SnackBar vert
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }

          // Erreur → SnackBar rouge
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        // BlocBuilder reconstruit l'UI à chaque changement d'état
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return _buildLoading();
            }
            if (state is ProfileError) {
              return _buildError(context, state.message);
            }
            if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
              final profile = state is ProfileLoaded
                  ? state.profile
                  : (state as ProfileUpdateSuccess).profile;
              return _buildContent(context, profile);
            }
            return _buildLoading();
          },
        ),
      ),
    );
  }

  // ── Contenu principal ─────────────────────────────────────────
  Widget _buildContent(BuildContext context, profile) {
    return CustomScrollView(
      slivers: [
        // AppBar avec retour
        SliverAppBar(
          expandedHeight: 0,
          floating: true,
          backgroundColor: const Color(0xFF2563EB),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Mon profil',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          actions: [
            // Bouton modifier (crayon)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              tooltip: 'Modifier le profil',
              onPressed: () => context.push('/profile/edit'),
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Column(
            children: [
              // ── En-tête avec photo + nom + email ───────────
              ProfileHeader(profile: profile),

              const SizedBox(height: 24),

              // ── Carte d'informations ────────────────────────
              ProfileInfoCard(profile: profile),

              const SizedBox(height: 16),

              // ── Section options ─────────────────────────────
              _buildOptionsSection(context),

              const SizedBox(height: 16),

              // ── Bouton déconnexion ──────────────────────────
              const LogoutButton(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  // ── Section des options supplémentaires ──────────────────────
  Widget _buildOptionsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _OptionTile(
            icon: Icons.edit_rounded,
            iconColor: const Color(0xFF2563EB),
            label: 'Modifier le profil',
            isFirst: true,
            onTap: () => context.push('/profile/edit'),
          ),
          const Divider(height: 1, indent: 60),
          _OptionTile(
            icon: Icons.security_rounded,
            iconColor: const Color(0xFF7C3AED),
            label: 'Changer le mot de passe',
            onTap: () {
              // TODO : Page de changement de mot de passe (étape suivante)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fonctionnalité bientôt disponible',
                      style: GoogleFonts.poppins(fontSize: 13)),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 60),
          _OptionTile(
            icon: Icons.settings_rounded,
            iconColor: const Color(0xFF10B981),
            label: 'Paramètres',
            isLast: true,
            onTap: () {
              // TODO : Page paramètres (étape suivante)
            },
          ),
        ],
      ),
    );
  }

  // ── Écran de chargement ───────────────────────────────────────
  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: Color(0xFFF1F5F9),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2563EB),
          strokeWidth: 3,
        ),
      ),
    );
  }

  // ── Écran d'erreur avec bouton réessayer ─────────────────────
  Widget _buildError(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 56, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid != null) {
                    context.read<ProfileBloc>().add(LoadProfile(uid));
                  }
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Réessayer',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget interne : tuile option cliquable ───────────────────
class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(20) : Radius.zero,
        bottom: isLast ? const Radius.circular(20) : Radius.zero,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: isFirst ? 18 : 14,
          bottom: isLast ? 18 : 14,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }
}
