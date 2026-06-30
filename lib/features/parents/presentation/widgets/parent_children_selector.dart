// ════════════════════════════════════════════════════════════════
// WIDGET : ParentChildrenSelector (parent_children_selector.dart)
// Rôle   : Permet à l'admin de sélectionner un ou plusieurs élèves
//          (collection Firestore 'students') à associer à un parent.
//          Supporte l'ajout ET la suppression d'enfants déjà liés.
//          Les IDs sélectionnés remontent via le callback [onChanged].
// ════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParentChildrenSelector extends StatefulWidget {
  /// Liste des IDs déjà sélectionnés (pré-remplie en mode modification)
  final List<String> initialSelectedIds;

  /// Appelé à chaque changement de sélection (ajout ou retrait)
  final void Function(List<String> selectedIds) onChanged;

  const ParentChildrenSelector({
    super.key,
    required this.initialSelectedIds,
    required this.onChanged,
  });

  @override
  State<ParentChildrenSelector> createState() =>
      _ParentChildrenSelectorState();
}

class _ParentChildrenSelectorState extends State<ParentChildrenSelector> {
  // IDs actuellement sélectionnés (copie mutable de la liste reçue)
  late List<String> _selectedIds;

  // Liste de tous les élèves chargés depuis Firestore
  List<Map<String, dynamic>> _students = [];
  bool _loading = true;
  String? _error;

  // Texte de recherche dans la liste d'élèves
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = List<String>.from(widget.initialSelectedIds);
    _loadStudents();
  }

  // Charge tous les élèves depuis la collection Firestore "students"
  Future<void> _loadStudents() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('students')
          .orderBy('prenom')
          .get();

      setState(() {
        _students = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            // On construit le nom complet depuis prenom + nom
            'name': '${data['prenom'] ?? ''} ${data['nom'] ?? ''}'.trim(),
            'classe': data['classe'] ?? '',
          };
        }).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur de chargement des élèves';
        _loading = false;
      });
    }
  }

  // Filtre la liste d'élèves selon le texte de recherche
  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return _students;
    final q = _searchQuery.toLowerCase();
    return _students
        .where((s) =>
            s['name'].toString().toLowerCase().contains(q) ||
            s['classe'].toString().toLowerCase().contains(q))
        .toList();
  }

  // Ajoute ou retire un élève de la sélection
  void _toggle(String studentId) {
    setState(() {
      if (_selectedIds.contains(studentId)) {
        _selectedIds.remove(studentId); // Désassociation
      } else {
        _selectedIds.add(studentId); // Association
      }
    });
    widget.onChanged(_selectedIds); // On informe le formulaire parent
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label + compteur de sélection ──────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enfants associés',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF475569),
              ),
            ),
            if (_selectedIds.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_selectedIds.length} sélectionné${_selectedIds.length > 1 ? 's' : ''}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 10),

        // ── Conteneur avec recherche + liste cochable ──────
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              // Barre de recherche interne
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: GoogleFonts.poppins(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un élève…',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 12, color: const Color(0xFFCBD5E1)),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFFCBD5E1), size: 18),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xFF2563EB), width: 1.5),
                    ),
                  ),
                ),
              ),

              const Divider(height: 1),

              // ── Corps de la liste selon l'état du chargement ──
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF2563EB), strokeWidth: 2),
                  ),
                )
              else if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: GoogleFonts.poppins(
                        color: Colors.red.shade400, fontSize: 12),
                  ),
                )
              else if (_filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Aucun élève trouvé',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: const Color(0xFF94A3B8)),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                // Hauteur fixe avec scroll interne pour éviter
                // de prendre toute la hauteur de l'écran
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (context, index) {
                      final student = _filtered[index];
                      final isSelected = _selectedIds.contains(student['id']);
                      return _StudentCheckTile(
                        name: student['name'],
                        classe: student['classe'],
                        isSelected: isSelected,
                        onToggle: () => _toggle(student['id']),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Widget interne : une ligne élève avec case à cocher ─────────
class _StudentCheckTile extends StatelessWidget {
  final String name;
  final String classe;
  final bool isSelected;
  final VoidCallback onToggle;

  const _StudentCheckTile({
    required this.name,
    required this.classe,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Case à cocher animée
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),

            // Nom et classe de l'élève
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    classe,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
