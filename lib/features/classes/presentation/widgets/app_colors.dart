// ============================================================
// FICHIER : presentation/widgets/app_colors.dart
//
// RÔLE : Centralise les couleurs du projet SchoolTrack.
// Plutôt que d'écrire Color(0xFF2563EB) partout dans le code,
// on utilise AppColors.blue partout. Si la couleur change,
// on la change juste ici.
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  // Couleur principale bleue (boutons, icônes actives, accents)
  static const Color blue = Color(0xFF2563EB);

  // Couleur secondaire verte (badges, succès, statistiques)
  static const Color green = Color(0xFF10B981);

  // Gris clair pour les fonds de champs de formulaire
  static const Color fieldBackground = Color(0xFFF8FAFC);

  // Gris pour les textes secondaires (sous-titres, hints)
  static const Color textSecondary = Color(0xFF6B7280);

  // Gris très clair pour les bordures
  static const Color border = Color(0xFFE5E7EB);

  // Fond principal de l'application
  static const Color background = Color(0xFFF9FAFB);

  // Constructeur privé : cette classe ne doit jamais être instanciée
  AppColors._();
}
