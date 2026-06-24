// ===========================================================
// FICHIER : profile_page.dart
// CHEMIN  : features/auth/presentation/pages/profile_page.dart
//
// RÔLE : Exemple complet d'une page de profil montrant :
//   - Comment afficher les infos de l'utilisateur connecté
//   - Comment déclencher la déconnexion via AuthBloc
//   - Comment rediriger vers LoginPage après déconnexion
//
// Intégrez ce pattern dans votre vraie ProfilePage.
// ===========================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';

import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // Écoute uniquement les changements d'état pour la navigation
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Déconnexion réussie → LoginPage
          // pushAndRemoveUntil supprime tout l'historique de navigation
          // L'utilisateur ne peut pas revenir en arrière avec le bouton retour
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false, // Supprime toutes les routes précédentes
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'Mon profil',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF2563EB),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          // Bouton modifier dans l'AppBar
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                // TODO: ouvrir la page d'édition du profil
              },
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // On vérifie que l'état est bien "connecté"
            if (state is! AuthAuthenticated) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = state.user;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ── En-tête avec photo et nom ──────────────
                  _buildHeader(user.name, user.email, user.photoUrl, user.role),

                  const SizedBox(height: 16),

                  // ── Informations du compte ─────────────────
                  _buildInfoCard(context, user.uid, user.email, user.schoolId),

                  const SizedBox(height: 16),

                  // ── Section déconnexion ────────────────────
                  _buildSignOutSection(context, state),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── En-tête profil ────────────────────────────────────────
  Widget _buildHeader(String name, String email, String photoUrl, String role) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        children: [
          // Photo de profil
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.white,
            backgroundImage: photoUrl.isNotEmpty
                ? NetworkImage(photoUrl)
                : null,
            child: photoUrl.isEmpty
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  )
                : null,
          ),

          const SizedBox(height: 16),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          // Badge rôle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: role == 'admin'
                  ? const Color(0xFF10B981).withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: role == 'admin'
                    ? const Color(0xFF10B981)
                    : Colors.orange,
                width: 1,
              ),
            ),
            child: Text(
              role == 'admin' ? ' Administrateur' : 'Parent',
              style: TextStyle(
                color: role == 'admin'
                    ? const Color(0xFF10B981)
                    : Colors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Carte d'informations ──────────────────────────────────
  Widget _buildInfoCard(
    BuildContext context,
    String uid,
    String email,
    String schoolId,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.badge_outlined,
            label: 'Identifiant (ownerId)',
            value: uid.length > 16 ? '${uid.substring(0, 16)}...' : uid,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.school_outlined,
            label: 'École',
            value: schoolId.isEmpty ? 'Non configurée' : schoolId,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 56, color: Colors.grey.shade100);
  }

  // ── Section déconnexion ───────────────────────────────────
  Widget _buildSignOutSection(BuildContext context, AuthAuthenticated state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          // ── Bouton déconnexion ──────────────────────────────
          // C'est LE bouton essentiel : il envoie SignOut au BLoC,
          // qui appelle FirebaseAuth.signOut() + GoogleSignIn.signOut()
          // Le BlocListener ci-dessus redirige vers LoginPage.
          ListTile(
            onTap: () => _showSignOutDialog(context),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: Colors.red.shade600,
                size: 20,
              ),
            ),
            title: Text(
              'Se déconnecter',
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Vous serez redirigé vers la page de connexion',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.red.shade300),
          ),
        ],
      ),
    );
  }

  // ── Dialogue de confirmation avant déconnexion ────────────
  Future<void> _showSignOutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Se déconnecter ?'),
        content: const Text(
          'Vous devrez vous reconnecter avec\nvotre compte Google.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // ── Envoi de l'événement SignOut au BLoC ────────────
      // Le BLoC appelle FirebaseAuth.signOut() + GoogleSignIn.signOut()
      // Puis émet AuthUnauthenticated
      // Le BlocListener dans build() redirige vers LoginPage
      context.read<AuthBloc>().add(const SignOut());
    }
  }
}
