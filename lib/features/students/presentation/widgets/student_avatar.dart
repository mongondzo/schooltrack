// WIDGET : Avatar de l'élève
// Widget réutilisable qui affiche les initiales d'un élève dans un cercle
// coloré. Utilisé dans la liste et la page de détails.
// Un widget séparé = plus facile à maintenir et à réutiliser ailleurs.

import 'package:flutter/material.dart';
import '../../domain/entities/student.dart';

class StudentAvatar extends StatelessWidget {
  final Student student;
  final double radius; // Taille du cercle (rayon)
  final double fontSize; // Taille du texte des initiales

  const StudentAvatar({
    super.key,
    required this.student,
    this.radius = 28,
    this.fontSize = 16,
  });

  // Génère une couleur unique basée sur le nom de l'élève
  // Chaque élève aura toujours la même couleur (déterministe)
  Color _getAvatarColor() {
    const colors = [
      Color(0xFF2563EB), // Bleu principal
      Color(0xFF10B981), // Vert principal
      Color(0xFF7C3AED), // Violet
      Color(0xFFEF4444), // Rouge
      Color(0xFFF59E0B), // Orange
      Color(0xFF06B6D4), // Cyan
      Color(0xFFEC4899), // Rose
    ];
    // hashCode est unique par nom, modulo donne un index valide
    final index = student.nom.hashCode % colors.length;
    return colors[index.abs()];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _getAvatarColor(),
      child: Text(
        student.initiales,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
