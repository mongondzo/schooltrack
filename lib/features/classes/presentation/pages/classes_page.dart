// ============================================================
// FICHIER : presentation/pages/classes_page.dart
//
// RÔLE : Page principale de la feature Classes.
// Affiche la liste de toutes les classes avec une barre de
// recherche locale et un bouton pour ajouter une classe.
//
// COMMENT ÇA MARCHE :
//   1. La page s'ouvre → initState envoie LoadClasses au BLoC
//   2. BLoC émet ClassLoading → on affiche un spinner
//   3. BLoC émet ClassLoaded → on affiche la liste
//   4. Si erreur → ClassError → on affiche le message
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/class_bloc.dart';
import '../bloc/class_event.dart';
import '../bloc/class_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/class_card.dart';
import '../../domain/entities/class_entity.dart';
import 'add_class_page.dart';
import 'edit_class_page.dart';
import 'class_details_page.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  // Texte tapé dans la barre de recherche
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Dès que la page s'affiche, on demande au BLoC de charger les classes
    context.read<ClassBloc>().add(LoadClasses());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtre la liste selon la recherche de l'utilisateur.
  // La recherche est locale (pas de requête Firestore supplémentaire).
  List<ClassEntity> _filterClasses(List<ClassEntity> classes) {
    if (_searchQuery.trim().isEmpty) return classes;

    final query = _searchQuery.toLowerCase();
    return classes.where((c) {
      return c.nomClasse.toLowerCase().contains(query) ||
          c.niveau.toLowerCase().contains(query);
    }).toList();
  }

  // Boîte de dialogue de confirmation avant suppression
  Future<void> _confirmDelete(
      BuildContext context, String id, String nom) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer la classe'),
        content: Text(
          'Voulez-vous vraiment supprimer "$nom" ?\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ClassBloc>().add(DeleteClass(id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Classe supprimée'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Classes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            fontSize: 20,
          ),
        ),
        // Bouton de rechargement manuel (pratique pour les débutants)
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.blue),
            onPressed: () => context.read<ClassBloc>().add(LoadClasses()),
            tooltip: 'Actualiser',
          ),
        ],
      ),

      // Bouton flottant "+" pour ajouter une classe
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddClassPage()),
          );
        },
        backgroundColor: AppColors.blue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Ajouter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          // --- Barre de recherche ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // setState reconstruit juste la liste filtrée,
                // sans rappeler Firestore
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Rechercher une classe…',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.fieldBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // --- Liste des classes ---
          // BlocBuilder se reconstruit automatiquement à chaque nouveau
          // state émis par le ClassBloc.
          Expanded(
            child: BlocBuilder<ClassBloc, ClassState>(
              builder: (context, state) {
                // Pendant le chargement
                if (state is ClassLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.blue),
                  );
                }

                // En cas d'erreur
                if (state is ClassError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<ClassBloc>().add(LoadClasses()),
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Données chargées avec succès
                if (state is ClassLoaded) {
                  final filtered = _filterClasses(state.classes);

                  // Aucune classe trouvée
                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.class_outlined,
                              size: 64,
                              color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'Aucune classe ajoutée'
                                : 'Aucun résultat pour "$_searchQuery"',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // On affiche aussi le nombre total en en-tête
                  return Column(
                    children: [
                      // En-tête : nombre de classes
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Row(
                          children: [
                            Text(
                              '${filtered.length} classe${filtered.length > 1 ? 's' : ''}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Liste
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final classe = filtered[index];
                            return ClassCard(
                              classEntity: classe,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ClassDetailsPage(classEntity: classe),
                                  ),
                                );
                              },
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditClassPage(classEntity: classe),
                                  ),
                                );
                              },
                              onDelete: () =>
                                  _confirmDelete(context, classe.id, classe.nomClasse),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                // ClassInitial (état de départ)
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
