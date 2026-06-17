# Feature Classes — SchoolTrack
## Guide d'intégration (pour débutants)

---

## 📁 Arborescence des fichiers générés

```
features/classes/
│
├── domain/                          ← Logique "pure", pas de Firestore
│   ├── entities/
│   │   └── class_entity.dart        ← L'objet ClassEntity (les données)
│   └── repositories/
│       └── class_repository.dart    ← Contrat : "que peut-on faire ?"
│
├── data/                            ← Tout ce qui parle à Firestore
│   ├── models/
│   │   └── class_model.dart         ← Conversion JSON ↔ ClassEntity
│   ├── datasources/
│   │   └── class_firestore_datasource.dart  ← Appels Firestore directs
│   └── repositories/
│       └── class_repository_impl.dart       ← Implémentation du contrat
│
└── presentation/                    ← Interface utilisateur
    ├── bloc/
    │   ├── class_event.dart         ← Actions déclenchables (LoadClasses…)
    │   ├── class_state.dart         ← États possibles (Loading, Loaded…)
    │   └── class_bloc.dart          ← Le cerveau : gère events → states
    ├── pages/
    │   ├── classes_page.dart        ← Liste des classes
    │   ├── add_class_page.dart      ← Formulaire d'ajout
    │   ├── edit_class_page.dart     ← Formulaire de modification
    │   └── class_details_page.dart  ← Détails d'une classe
    ├── widgets/
    │   ├── app_colors.dart          ← Couleurs centralisées
    │   ├── class_card.dart          ← Carte d'une classe dans la liste
    │   ├── class_form.dart          ← Formulaire réutilisable
    │   └── info_row.dart            ← Ligne "label : valeur" (détails)
    └── routes/
        └── class_routes.dart        ← Noms et génération des routes
```

---

## 📦 Dépendances requises dans `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6      # Gestion d'état BLoC
  firebase_core: ^3.x.x     # Firebase (déjà présent normalement)
  cloud_firestore: ^5.x.x   # Base de données Firestore
  intl: ^0.19.0             # Formatage des dates (page détails)
```

Après avoir modifié pubspec.yaml, exécutez :
```bash
flutter pub get
```

---

## ⚙️ Étape 1 — Configurer le BLoC dans main.dart

Le BLoC doit être disponible dans toute l'application.
Modifiez votre `main.dart` (ou le fichier où vous avez votre `MaterialApp`) :

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/classes/data/datasources/class_firestore_datasource.dart';
import 'features/classes/data/repositories/class_repository_impl.dart';
import 'features/classes/presentation/bloc/class_bloc.dart';
import 'features/classes/presentation/bloc/class_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // On crée le repository et le BLoC ici, une seule fois.
    final classRepository = ClassRepositoryImpl(
      dataSource: ClassFirestoreDataSource(),
    );

    return MultiBlocProvider(
      providers: [
        // Vos autres BlocProvider existants (étudiants, dashboard...)
        // BlocProvider<StudentBloc>(create: (_) => StudentBloc(...)),

        // Ajoutez celui-ci :
        BlocProvider<ClassBloc>(
          create: (_) => ClassBloc(repository: classRepository),
        ),
      ],
      child: MaterialApp(
        title: 'SchoolTrack',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
          useMaterial3: true,
        ),
        // Utilisez onGenerateRoute pour gérer les routes nommées
        onGenerateRoute: (settings) {
          return ClassRoutes.generate(settings);
          // Si vous avez d'autres routes :
          // return ClassRoutes.generate(settings) ??
          //        AutreRoutes.generate(settings);
        },
        home: const ClassesPage(), // ou votre page d'accueil
      ),
    );
  }
}
```

---

## 🗺️ Étape 2 — Naviguer vers les classes

Depuis n'importe quelle page (ex: Dashboard) :

```dart
import 'features/classes/presentation/routes/class_routes.dart';

// Aller à la liste des classes
Navigator.pushNamed(context, ClassRoutes.list);

// OU navigation directe (sans routes nommées)
import 'features/classes/presentation/pages/classes_page.dart';
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const ClassesPage()),
);
```

---

## 🔥 Étape 3 — Structure Firestore

Collection : **`classes`**

Exemple de document Firestore :
```json
{
  "nomClasse": "6ème A",
  "niveau": "6ème",
  "effectif": 25,
  "description": "Classe principale, bâtiment A",
  "createdAt": <Timestamp>
}
```

> L'identifiant du document (`id`) est géré automatiquement par Firestore.
> Ne l'ajoutez pas manuellement dans les champs.

---

## 🌍 Étape 4 — Locale française (optionnel)

La page de détails utilise `intl` pour formater la date en français.
Pour activer la locale française, ajoutez dans `main.dart` :

```dart
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('fr_FR', null); // ← Ajouter cette ligne
  runApp(const MyApp());
}
```

Si vous ne voulez pas de locale française, remplacez dans
`class_details_page.dart` la ligne :
```dart
return DateFormat("d MMM yyyy 'à' HH:mm", 'fr_FR').format(date);
```
par :
```dart
return DateFormat('dd/MM/yyyy HH:mm').format(date);
```

---

## 🚀 Flux de données (résumé)

```
Interface (Page)
    │
    ├─ bloc.add(LoadClasses())
    │
    ▼
ClassBloc (cerveau)
    │
    ├─ appelle repository.getClasses()
    │
    ▼
ClassRepositoryImpl (pont)
    │
    ├─ appelle datasource.getClasses()
    │
    ▼
ClassFirestoreDataSource (Firestore)
    │
    ├─ lit la collection "classes"
    │
    ▼  (résultat remonte dans l'autre sens)
    
ClassBloc émet ClassLoaded(classes)
    │
    ▼
BlocBuilder reconstruit la liste dans l'interface ✓
```

---

## ❓ Questions fréquentes

**Q : Pourquoi ne pas appeler Firestore directement dans la page ?**
R : Le BLoC sépare la logique de l'interface. Si Firestore change,
   vous ne modifiez que le datasource, pas les pages.

**Q : Pourquoi `id: ''` quand on ajoute une classe ?**
R : Firestore génère automatiquement un ID unique via `.add()`.
   On n'a pas besoin de le créer nous-mêmes.

**Q : Comment recharger la liste depuis le dashboard ?**
R : Envoyez `context.read<ClassBloc>().add(LoadClasses())`.
   Le BLoC doit être fourni par `MultiBlocProvider` en haut de l'arbre.
