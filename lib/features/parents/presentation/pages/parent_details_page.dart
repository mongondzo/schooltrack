// ════════════════════════════════════════════════════════════════
// PAGE : ParentDetailsPage (parent_details_page.dart)
// Rôle  : Affiche toutes les informations d'un parent :
//         nom, email, téléphone, adresse, date de création,
//         et la liste des enfants associés (récupérés depuis
//         la collection Firestore 'students' à partir des
//         childrenIds du parent).
// ════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:schooltrack/features/parents/domain/entities/parent_entity.dart';

class ParentDetailsPage extends StatefulWidget {
  final ParentEntity parent;

  const ParentDetailsPage({super.key, required this.parent});

  @override
  State<ParentDetailsPage> createState() => _ParentDetailsPageState();
}

class _ParentDetailsPageState extends State<ParentDetailsPage> {
  // Liste des enfants récupérés depuis Firestore (nom + classe)
  List<Map<String, dynamic>> _children = [];
  bool _loadingChildren = true;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  // Récupère les détails (nom, classe) de chaque enfant associé
  // en interrogeant la collection 'students' avec les childrenIds
  Future<void> _loadChildren() async {
    if (widget.parent.childrenIds.isEmpty) {
      setState(() => _loadingChildren = false);
      return;
    }

    try {
      final List<Map<String, dynamic>> results = [];

      // On récupère chaque élève un par un grâce à son ID
      // (whereIn serait possible mais limité à 10 éléments par Firestore)
      for (final studentId in widget.parent.childrenIds) {
        final doc = await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          results.add({
            'name': '${data['prenom'] ?? ''} ${data['nom'] ?? ''}'.trim(),
            'classe': data['classe'] ?? '',
          });
        }
      }

      setState(() {
        _children = results;
        _loadingChildren = false;
      });
    } catch (e) {
      setState(() => _loadingChildren = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final parent = widget.parent;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          // ── AppBar avec en-tête bleu ────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF2563EB),
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () =>
                    context.push('/parents/${parent.id}/edit', extra: parent),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar avec initiales
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Text(
                              parent.initials,
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          parent.name,
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          parent.email,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Contenu principal ───────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Carte des informations de contact ──────
                  _buildInfoCard(parent),

                  const SizedBox(height: 20),

                  // ── Section enfants associés ───────────────
                  _buildChildrenSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Carte avec téléphone, adresse, date de création
  Widget _buildInfoCard(ParentEntity parent) {
    return Container(
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
          _infoRow(
            icon: Icons.phone_outlined,
            iconColor: const Color(0xFF2563EB),
            label: 'Téléphone',
            value: parent.phone,
            isFirst: true,
          ),
          const Divider(height: 1, indent: 60),
          _infoRow(
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFF7C3AED),
            label: 'Adresse',
            value: parent.address,
          ),
          const Divider(height: 1, indent: 60),
          _infoRow(
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF10B981),
            label: 'Date de création',
            value: DateFormat('dd MMMM yyyy', 'fr').format(parent.createdAt),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: isFirst ? 20 : 14,
        bottom: isLast ? 20 : 14,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value.isNotEmpty ? value : 'Non renseigné',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section listant les enfants associés au parent
  Widget _buildChildrenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enfants associés (${widget.parent.childrenCount})',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),

        if (_loadingChildren)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                  color: Color(0xFF2563EB), strokeWidth: 2),
            ),
          )
        else if (_children.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Aucun enfant associé à ce parent',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: const Color(0xFF94A3B8)),
              ),
            ),
          )
        else
          Column(
            children: _children
                .map((child) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.school_rounded,
                                color: Color(0xFF2563EB), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(child['name'],
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E293B))),
                              Text(child['classe'],
                                  style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: const Color(0xFF94A3B8))),
                            ],
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }
}
