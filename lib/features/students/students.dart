// Un "barrel file" (fichier tonneau) regroupe tous les exports d'une feature.
// Au lieu d'écrire 10 imports dans chaque fichier, on n'en écrit qu'un seul :
//   import 'features/students/students.dart';
// Et on a accès à tout ce qui est exporté ici.

// Entité
export 'domain/entities/student.dart';

// Repository (contrat)
export 'domain/repositories/student_repository.dart';

// BLoC
export 'presentation/bloc/student_bloc.dart';
export 'presentation/bloc/student_event.dart';
export 'presentation/bloc/student_state.dart';

// Pages
export 'presentation/pages/student_list_page.dart';
export 'presentation/pages/add_student_page.dart';
export 'presentation/pages/edit_student_page.dart';
export 'presentation/pages/student_detail_page.dart';

// Widgets
export 'presentation/widgets/student_avatar.dart';
export 'presentation/widgets/student_list_tile.dart';
export 'presentation/widgets/student_form.dart';

// Injection de dépendances
export 'student_dependencies.dart';
