import 'package:flutter/material.dart';
import '../../domain/entities/class_entity.dart';
import '../pages/add_class_page.dart';
import '../pages/class_details_page.dart';
import '../pages/classes_page.dart';
import '../pages/edit_class_page.dart';

class ClassRoutes {
  // Noms des routes (constantes pour éviter les fautes de frappe)
  static const String list = '/classes';
  static const String add = '/classes/add';
  static const String edit = '/classes/edit';
  static const String details = '/classes/details';

  // Constructeur privé : classe utilitaire, pas d'instances
  ClassRoutes._();

  /// Génère la route demandée. Retourne null si le nom n'est pas
  /// géré par cette feature (les autres features prendront le relais).
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      // --- Liste des classes ---
      case list:
        return MaterialPageRoute(builder: (_) => const ClassesPage());

      // --- Ajouter une classe ---
      case add:
        return MaterialPageRoute(builder: (_) => const AddClassPage());

      // --- Modifier une classe ---
      // L'appelant doit passer une ClassEntity dans arguments :
      // Navigator.pushNamed(context, ClassRoutes.edit, arguments: entity);
      case edit:
        final entity = settings.arguments as ClassEntity?;
        if (entity == null) {
          return _errorRoute(
            'ClassRoutes.edit nécessite une ClassEntity en argument.',
          );
        }
        return MaterialPageRoute(
          builder: (_) => EditClassPage(classEntity: entity),
        );

      // --- Détails d'une classe ---
      // Même principe : passer une ClassEntity dans arguments.
      case details:
        final entity = settings.arguments as ClassEntity?;
        if (entity == null) {
          return _errorRoute(
            'ClassRoutes.details nécessite une ClassEntity en argument.',
          );
        }
        return MaterialPageRoute(
          builder: (_) => ClassDetailsPage(classEntity: entity),
        );

      default:
        return null; // Route non gérée par cette feature
    }
  }

  // Route d'erreur affichée si un argument est manquant
  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '⚠️ Erreur de navigation :\n$message',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
