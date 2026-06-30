// ════════════════════════════════════════════════════════════════
// PAGE : ParentsPage (parents_page.dart)
// Rôle  : Écran principal — liste des parents, barre de recherche,
//         bouton flottant pour ajouter. Gère la confirmation
//         de suppression et navigue vers les autres pages.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schooltrack/features/parents/presentation/bloc/parent_bloc.dart';
import 'package:schooltrack/features/parents/presentation/pages/add_parent_page.dart';
import 'package:schooltrack/features/parents/presentation/widgets/empty_parents_widget.dart';
import 'package:schooltrack/features/parents/presentation/widgets/parent_card.dart';

class ParentsPage extends StatefulWidget {
  const ParentsPage({super.key});

  @override
  State<ParentsPage> createState() => _ParentsPageState();
}

class _ParentsPageState extends State<ParentsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Chargement de la liste des parents dès l'ouverture de la page
    context.read<ParentBloc>().add(LoadParents());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Affiche une boîte de dialogue de confirmation avant suppression
  Future<void> _confirmDelete(
    BuildContext context,
    String parentId,
    String parentName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Supprimer le parent',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Voulez-vous vraiment supprimer "$parentName" ?\nCette action est irréversible.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Annuler',
              style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Supprimer',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<ParentBloc>().add(DeleteParent(parentId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: BlocConsumer<ParentBloc, ParentState>(
        listener: (context, state) {
          // SnackBar de succès (ajout / modif / suppression réussis)
          if (state is ParentLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message!,
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
          // SnackBar d'erreur
          if (state is ParentError) {
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
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // ── AppBar ─────────────────────────────────────
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                snap: true,
                backgroundColor: const Color(0xFF2563EB),
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  'Parents',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      color: Colors.white,
                    ),
                    tooltip: 'Ajouter un parent',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddParentPage()),
                      );
                    },
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 16),

                      if (state is ParentLoading || state is ParentInitial)
                        _buildSkeleton()
                      else if (state is ParentLoaded)
                        _buildList(context, state)
                      else if (state is ParentError)
                        _buildError(context, state.message)
                      else
                        _buildSkeleton(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // Bouton flottant pour ajouter un parent rapidement
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/parents/add'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: Text(
          'Ajouter',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 3,
      ),
    );
  }

  // ── Barre de recherche ────────────────────────────────────────
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (v) {
        if (v.isEmpty) {
          context.read<ParentBloc>().add(ClearParentSearch());
        } else {
          context.read<ParentBloc>().add(SearchParents(v));
        }
      },
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Rechercher un parent…',
        hintStyle: GoogleFonts.poppins(
          fontSize: 13,
          color: const Color(0xFFCBD5E1),
        ),
        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                onPressed: () {
                  _searchController.clear();
                  context.read<ParentBloc>().add(ClearParentSearch());
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
    );
  }

  // ── Liste des parents ─────────────────────────────────────────
  Widget _buildList(BuildContext context, ParentLoaded state) {
    if (state.parents.isEmpty) {
      return EmptyParentsWidget(
        onAdd: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ParentsPage()),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            state.isSearching
                ? '${state.parents.length} résultat${state.parents.length > 1 ? 's' : ''}'
                : '${state.parents.length} parent${state.parents.length > 1 ? 's' : ''} au total',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ),
        ...state.parents.map(
          (parent) => ParentCard(
            parent: parent,
            // On transmet l'objet parent complet via `extra` pour que
            // ParentDetailsPage et EditParentPage n'aient pas besoin
            // de le recharger depuis Firestore
            onTap: () => context.push('/parents/${parent.id}', extra: parent),
            onEdit: () =>
                context.push('/parents/${parent.id}/edit', extra: parent),
            onDelete: () => _confirmDelete(context, parent.id, parent.name),
          ),
        ),
        const SizedBox(height: 80), // Espace pour le FAB
      ],
    );
  }

  // ── Skeleton loader (chargement) ──────────────────────────────
  Widget _buildSkeleton() {
    return Column(
      children: List.generate(
        5,
        (_) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const _SkeletonShimmer(),
        ),
      ),
    );
  }

  // ── Affichage d'erreur ────────────────────────────────────────
  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<ParentBloc>().add(LoadParents()),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(
              'Réessayer',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget interne : effet shimmer pour le skeleton loader ─────
class _SkeletonShimmer extends StatefulWidget {
  const _SkeletonShimmer();

  @override
  State<_SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<_SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 14,
                      width: 140,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 11,
                      width: 200,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 11,
                      width: 100,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
