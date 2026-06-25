// ════════════════════════════════════════════════════════════════
// FICHIER D'INTÉGRATION : integration_guide.dart
// Ce fichier N'EST PAS à copier dans ton projet.
// C'est un guide commenté expliquant comment intégrer
// la fonctionnalité Profile dans ton projet SchoolTrack existant.
// ════════════════════════════════════════════════════════════════


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ÉTAPE 1 — COPIER LES FICHIERS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Copie le dossier entier dans ton projet :
//
//   lib/features/profile/   →   lib/features/profile/
//
// Structure finale attendue dans ton projet :
//
//   lib/
//   └── features/
//       ├── auth/            ✅ déjà là
//       ├── dashboard/       ✅ déjà là
//       ├── students/        ✅ déjà là
//       ├── classes/         ✅ déjà là
//       ├── grades/          ✅ déjà là
//       ├── attendance/      ✅ déjà là
//       ├── notifications/   ✅ déjà là
//       └── profile/         ← NOUVEAU (copier ici)


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ÉTAPE 2 — AJOUTER LES ROUTES dans app_router.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Ouvre :  lib/core/routes/app_router.dart
//
// Ajoute ces imports en haut du fichier :
/*
import 'package:schooltrack/features/profile/presentation/pages/profile_page.dart';
import 'package:schooltrack/features/profile/presentation/pages/edit_profile_page.dart';
*/
//
// Ajoute ces deux routes dans la liste `routes:` de GoRouter,
// juste après la route du dashboard :
/*
GoRoute(
  path: '/profile',
  name: 'profile',
  builder: (context, state) => const ProfilePage(),
),
GoRoute(
  path: '/profile/edit',
  name: 'editProfile',
  builder: (context, state) => const EditProfilePage(),
),
*/


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ÉTAPE 3 — ENREGISTRER LE BLOC dans main.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Ouvre :  lib/main.dart
//
// Ajoute ces imports :
/*
import 'package:schooltrack/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:schooltrack/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:schooltrack/features/profile/presentation/bloc/profile_bloc.dart';
*/
//
// Dans la fonction main() ou dans le widget principal,
// là où tu crées tes autres blocs, ajoute :
/*
final profileRemoteDataSource = ProfileRemoteDataSourceImpl();
final profileRepository = ProfileRepositoryImpl(
  remoteDataSource: profileRemoteDataSource,
);
*/
//
// Dans MultiBlocProvider, ajoute un nouveau BlocProvider :
/*
BlocProvider<ProfileBloc>(
  create: (_) => ProfileBloc(repository: profileRepository),
),
*/
//
// Exemple de MultiBlocProvider complet dans main.dart :
/*
MultiBlocProvider(
  providers: [
    BlocProvider<AuthBloc>(create: (_) => authBloc),
    BlocProvider<DashboardBloc>(create: (_) => dashboardBloc),
    BlocProvider<StudentBloc>(create: (_) => studentBloc),
    BlocProvider<ClassBloc>(create: (_) => classBloc),
    // ... autres blocs existants ...
    BlocProvider<ProfileBloc>(   // ← AJOUTER ICI
      create: (_) => ProfileBloc(repository: profileRepository),
    ),
  ],
  child: MaterialApp.router(...),
)
*/


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ÉTAPE 4 — ACCÈS RAPIDE DEPUIS LE DASHBOARD
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Dans dashboard_page.dart, l'avatar utilisateur en haut à droite
// peut naviguer vers le profil. Trouve la fonction _buildWelcomeHeader()
// et modifie le GestureDetector de l'avatar ainsi :
/*
GestureDetector(
  onTap: () => context.push('/profile'),  // ← remplace l'ancien onTap
  child: Container(
    // ... code existant de l'avatar ...
  ),
),
*/
//
// Tu peux aussi ajouter un item dans la NavigationBar du bas :
/*
NavigationDestination(
  icon: const Icon(Icons.person_outline),
  selectedIcon: const Icon(
    Icons.person_rounded,
    color: Color(0xFF2563EB),
  ),
  label: 'Profil',
),
*/
// Et dans onDestinationSelected :
/*
case 3: context.push('/profile'); break;
*/


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ÉTAPE 5 — VÉRIFIER pubspec.yaml
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Ces packages doivent déjà être dans pubspec.yaml
// (ils étaient utilisés à l'étape 1) :
//
//   flutter_bloc: ^8.1.5
//   firebase_auth: ^4.17.8
//   cloud_firestore: ^4.15.8
//   google_sign_in: ^6.2.1
//   go_router: ^13.2.0
//   google_fonts: ^6.2.1
//   intl: ^0.18.0       ← NOUVEAU si pas encore présent
//
// Si intl n'est pas là, ajoute-le :
/*
dependencies:
  intl: ^0.18.0
*/
// Puis lance : flutter pub get


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ÉTAPE 6 — RÈGLES FIRESTORE (si pas déjà configurées)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
// Dans la console Firebase → Firestore → Rules :
/*
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Un utilisateur peut lire et modifier son propre profil
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    // Les admins peuvent tout lire
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
*/


// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// RÉSUMÉ DES FICHIERS CRÉÉS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
//  lib/features/profile/
//  ├── data/
//  │   ├── datasources/
//  │   │   └── profile_remote_datasource.dart   ← Firebase Auth + Firestore
//  │   ├── models/
//  │   │   └── profile_model.dart               ← fromMap / toMap / copyWith
//  │   └── repositories/
//  │       └── profile_repository_impl.dart     ← pont domaine ↔ data
//  │
//  ├── domain/
//  │   ├── entities/
//  │   │   └── profile_entity.dart              ← objet pur (roleLabel, initials)
//  │   └── repositories/
//  │       └── profile_repository.dart          ← contrat abstrait
//  │
//  └── presentation/
//      ├── bloc/
//      │   ├── profile_bloc.dart                ← logique (3 handlers)
//      │   ├── profile_event.dart               ← LoadProfile / Update / Logout
//      │   └── profile_state.dart               ← Initial / Loading / Loaded / Error
//      ├── pages/
//      │   ├── profile_page.dart                ← écran principal profil
//      │   └── edit_profile_page.dart           ← formulaire modification
//      └── widgets/
//          ├── profile_header.dart              ← photo + nom + email + badge
//          ├── profile_info_card.dart           ← téléphone + rôle + date
//          └── logout_button.dart              ← bouton déconnexion avec dialog

void integrationGuide() {
  // Ce fichier sert uniquement de documentation.
  // Supprime-le une fois l'intégration terminée.
}
