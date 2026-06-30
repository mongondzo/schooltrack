// ════════════════════════════════════════════════════════════════
// DATASOURCE : ParentRemoteDataSource (parent_remote_datasource.dart)
// Couche     : Data
// Rôle       : SEUL fichier du projet qui communique directement
//              avec Cloud Firestore pour la collection 'parents'.
//              Connexion directe — pas d'abstraction supplémentaire,
//              pas de gestion d'erreurs complexe (les erreurs
//              remontent simplement via les exceptions Dart natives).
// ════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schooltrack/features/parents/data/models/parent_model.dart';

// ── Interface ──────────────────────────────────────────────────
abstract class ParentRemoteDataSource {
  Future<List<ParentModel>> getParents();
  Future<void> addParent(ParentModel parent);
  Future<void> updateParent(ParentModel parent);
  Future<void> deleteParent(String id);
}

// ── Implémentation Firestore ───────────────────────────────────
class ParentRemoteDataSourceImpl implements ParentRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Raccourci vers la collection Firestore "parents"
  CollectionReference get _col => _firestore.collection('parents');

  // ── Lire tous les parents ─────────────────────────────────────
  // Tri alphabétique par nom, directement côté serveur Firestore
  @override
  Future<List<ParentModel>> getParents() async {
    final QuerySnapshot snapshot = await _col.orderBy('name').get();
    return snapshot.docs
        .map((doc) => ParentModel.fromFirestore(doc))
        .toList();
  }

  // ── Ajouter un parent ─────────────────────────────────────────
  // .add() génère automatiquement un ID unique dans Firestore
  @override
  Future<void> addParent(ParentModel parent) async {
    await _col.add(parent.toMap());
  }

  // ── Modifier un parent ────────────────────────────────────────
  // .update() ne modifie QUE les champs présents dans le Map
  @override
  Future<void> updateParent(ParentModel parent) async {
    await _col.doc(parent.id).update(parent.toMap());
  }

  // ── Supprimer un parent ───────────────────────────────────────
  @override
  Future<void> deleteParent(String id) async {
    await _col.doc(id).delete();
  }
}
