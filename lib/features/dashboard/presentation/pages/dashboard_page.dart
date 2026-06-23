import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_event.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_state.dart';
import 'package:schooltrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:schooltrack/features/dashboard/presentation/widgets/quick_action_button.dart';
import 'package:schooltrack/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:schooltrack/features/dashboard/presentation/widgets/stats_skeleton_loader.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(DashboardStatsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              snap: true,
              backgroundColor: const Color(0xFF2563EB),
              automaticallyImplyLeading: false,
              title: _buildAppBarTitle(),
              actions: [_buildNotificationIcon()],
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeHeader(),

                  // Cartes de statistiques principales
                  _buildStatsSection(),

                  // Cartes de performance
                  _buildPerformanceSection(),

                  // Actions rapides
                  _buildQuickActionsSection(),

                  // Espace en bas
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // Titre de l'AppBar
  Widget _buildAppBarTitle() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Color(0xFF2563EB),
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'SchoolTrack',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Icône de notification dans l'AppBar
  Widget _buildNotificationIcon() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        // Nombre de notifications (0 si pas encore chargé)
        final notifCount = state is DashboardLoaded
            ? state.stats.totalNotifications
            : 0;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {},
              ),
              // Badge rouge si des notifications existent
              if (notifCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.red.shade500,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        notifCount > 9 ? '9+' : '$notifCount',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // En-tête de bienvenue avec info utilisateur
  Widget _buildWelcomeHeader() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state is AuthAuthenticated ? state.user.name : 'Admin';
        final userPhoto = state is AuthAuthenticated
            ? state.user.photoUrl
            : null;
        final now = DateTime.now();
        final greeting = now.hour < 12
            ? 'Bonjour'
            : now.hour < 18
            ? 'Bon après-midi'
            : 'Bonsoir';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, Admin ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Voici un aperçu général',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar de l'utilisateur
              GestureDetector(
                onTap: () {
                  // Menu de déconnexion
                  _showLogoutMenu(context);
                },
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: ClipOval(
                    child: userPhoto != null
                        ? Image.network(
                            userPhoto,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _defaultAvatar(userName),
                          )
                        : _defaultAvatar(userName),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Avatar par défaut si pas de photo
  Widget _defaultAvatar(String name) {
    return Container(
      color: const Color(0xFF1E40AF),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'A',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Section des 4 cartes de statistiques principales
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vue d\'ensemble',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 14),

          // BlocBuilder écoute les changements d'état du DashboardBloc
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              // État chargement → afficher le skeleton
              if (state is DashboardLoading || state is DashboardInitial) {
                return const StatsSkeletonLoader();
              }

              // État erreur → afficher un message
              if (state is DashboardError) {
                return _buildErrorWidget(state.message);
              }

              // État chargé → afficher les vraies données
              if (state is DashboardLoaded) {
                final stats = state.stats;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                  children: [
                    // Carte Élèves
                    StatCard(
                      title: 'Élèves',
                      value: '${stats.totalStudents}',
                      icon: Icons.people_alt_rounded,
                      color: const Color(0xFF2563EB),
                      iconBgColor: const Color(0xFF1D4ED8),
                      subtitle: 'Voir plus',
                      onTap: () {
                        // TODO: Naviguer vers la liste des élèves
                      },
                    ),

                    // Carte Classes
                    StatCard(
                      title: 'Classes',
                      value: '${stats.totalClasses}',
                      icon: Icons.class_rounded,
                      color: const Color(0xFF059669),
                      iconBgColor: const Color(0xFF047857),
                      subtitle: 'Voir plus',
                      onTap: () {
                        // TODO: Naviguer vers les classes
                      },
                    ),

                    // Carte Présences
                    StatCard(
                      title: 'Présences',
                      value: '${stats.totalAttendances}',
                      icon: Icons.how_to_reg_rounded,
                      color: const Color(0xFFD97706),
                      iconBgColor: const Color(0xFFB45309),
                      subtitle: "Aujourd'hui",
                      onTap: () {
                        // TODO: Naviguer vers les présences
                      },
                    ),

                    // Carte Notifications
                    StatCard(
                      title: 'Notifications',
                      value: '${stats.totalNotifications}',
                      icon: Icons.notifications_rounded,
                      color: const Color(0xFF7C3AED),
                      iconBgColor: const Color(0xFF6D28D9),
                      subtitle: 'Non lues',
                      onTap: () {
                        // TODO: Naviguer vers les notifications
                      },
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  // Section des indicateurs de performance (notes et présences moyennes)
  Widget _buildPerformanceSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance générale',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Carte Moyenne des notes
              Expanded(
                child: _buildPerformanceCard(
                  label: 'Moyenne générale',
                  value: '85%',
                  icon: Icons.star_rounded,
                  color: const Color(0xFF0EA5E9),
                  progress: 0.85,
                ),
              ),
              const SizedBox(width: 14),

              // Carte Taux de présence
              Expanded(
                child: _buildPerformanceCard(
                  label: 'Taux présence',
                  value: '92%',
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFF10B981),
                  progress: 0.92,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Carte de performance avec barre de progression
  Widget _buildPerformanceCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          const SizedBox(height: 12),

          // Valeur
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),

          // Label
          Text(
            label,
            style: TextStyle(fontSize: 12, color: const Color(0xFF64748B)),
          ),

          const SizedBox(height: 10),

          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // Section des actions rapides
  Widget _buildQuickActionsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickActionButton(
                  label: 'Ajouter\nélève',
                  icon: Icons.person_add_rounded,
                  color: const Color(0xFF2563EB),
                  onTap: () {
                    // TODO: Naviguer vers ajout d'élève
                  },
                ),
                QuickActionButton(
                  label: 'Ajouter\nclasse',
                  icon: Icons.add_box_rounded,
                  color: const Color(0xFF059669),
                  onTap: () {
                    // TODO: Naviguer vers ajout de classe
                  },
                ),
                QuickActionButton(
                  label: 'Nouvelle\nnote',
                  icon: Icons.edit_note_rounded,
                  color: const Color(0xFFD97706),
                  onTap: () {
                    // TODO: Naviguer vers ajout de note
                  },
                ),
                QuickActionButton(
                  label: 'Annonce',
                  icon: Icons.campaign_rounded,
                  color: const Color(0xFFDC2626),
                  onTap: () {
                    // TODO: Créer une annonce
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget d'erreur affiché si le chargement échoue
  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red.shade400,
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 12),
          // Bouton pour réessayer
          ElevatedButton.icon(
            onPressed: () {
              context.read<DashboardBloc>().add(DashboardStatsRequested());
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text('Réessayer', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Barre de navigation du bas
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          // TODO: Naviguer vers la page correspondante dans les prochaines étapes
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEFF6FF),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(
              Icons.home_rounded,
              color: Color(0xFF2563EB),
            ),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(
              Icons.people_rounded,
              color: Color(0xFF2563EB),
            ),
            label: 'Élèves',
          ),
          NavigationDestination(
            icon: const Icon(Icons.class_outlined),
            selectedIcon: const Icon(
              Icons.class_rounded,
              color: Color(0xFF2563EB),
            ),
            label: 'Classes',
          ),
          NavigationDestination(
            icon: const Icon(Icons.more_horiz_rounded),
            selectedIcon: const Icon(
              Icons.more_horiz_rounded,
              color: Color(0xFF2563EB),
            ),
            label: 'Plus',
          ),
        ],
      ),
    );
  }

  // Affiche un menu de déconnexion en bas de l'écran
  void _showLogoutMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barre de tirage
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 20),

              // Info utilisateur
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final name = state is AuthAuthenticated
                      ? state.user.name
                      : 'Admin';
                  final email = state is AuthAuthenticated
                      ? state.user.email
                      : '';
                  return Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Bouton déconnexion
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Déclenche la déconnexion via AuthBloc
                    context.read<AuthBloc>().add(AuthSignOutRequested());
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    'Se déconnecter',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
