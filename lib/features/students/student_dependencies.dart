// Ce fichier centralise la création de tous les objets de la feature students.
// L'injection de dépendances (DI) = fournir les dépendances à un objet
// plutôt que de le laisser les créer lui-même.
// Avantage : si on veut tester le BLoC, on peut lui passer un faux repository.
// COMMENT UTILISER :
// Dans ton main.dart ou dans l'arbre de widgets, appelle :
//   StudentDependencies.provideBloc(child: MonWidget())
// Ton widget peut alors accéder au BLoC via :
//   context.read<StudentBloc>()

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:schooltrack/features/students/data/datasources/student_remote_datasource.dart';
import 'package:schooltrack/features/students/data/repositories/student_repository_impl.dart';
import 'package:schooltrack/features/students/presentation/bloc/student_bloc.dart';

class StudentDependencies {
  // Crée et fournit le StudentBloc à tous les widgets enfants.
  // Appelle cette méthode dans ton router ou dans le widget parent de la liste.
  static Widget provideBloc({required Widget child}) {
    return BlocProvider<StudentBloc>(
      // 'create' construit le BLoC et toute sa chaîne de dépendances
      create: (context) {
        // 1. Datasource : parle à Firebase
        final dataSource = StudentRemoteDataSourceImpl(
          firestore: FirebaseFirestore.instance,
        );

        // 2. Repository : utilise le datasource (couche data)
        final repository = StudentRepositoryImpl(remoteDataSource: dataSource);

        // 3. BLoC : utilise le repository (couche presentation)
        return StudentBloc(repository: repository, authBloc: AuthBloc());
      },
      child: child,
    );
  }
}
