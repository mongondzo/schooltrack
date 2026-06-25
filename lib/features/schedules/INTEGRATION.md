

---

## ⚙️ Étape 2 — Ajouter le ScheduleBloc dans main.dart

Ouvrez votre `main.dart` (ou le fichier contenant votre `MultiBlocProvider`)
et ajoutez le `ScheduleBloc` à côté des autres BLoC déjà présents.

```dart
// ── IMPORTS À AJOUTER ──────────────────────────────────────────────────────
import 'features/schedules/data/datasources/schedule_remote_datasource.dart';
import 'features/schedules/data/repositories/schedule_repository_impl.dart';
import 'features/schedules/presentation/bloc/schedule_bloc.dart';

// ── DANS VOTRE WIDGET MyApp ────────────────────────────────────────────────
@override
Widget build(BuildContext context) {
  return MultiBlocProvider(
    providers: [
      // Vos BlocProvider existants :
      BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
      BlocProvider<StudentBloc>(create: (_) => sl<StudentBloc>()),
      BlocProvider<ClassBloc>(create: (_) => sl<ClassBloc>()),
      BlocProvider<GradeBloc>(create: (_) => sl<GradeBloc>()),
      BlocProvider<AttendanceBloc>(create: (_) => sl<AttendanceBloc>()),

      // ✅ AJOUTEZ CELUI-CI :
      BlocProvider<ScheduleBloc>(
        create: (_) => ScheduleBloc(
          repository: ScheduleRepositoryImpl(
            dataSource: ScheduleRemoteDataSource(),
          ),
        ),
      ),
    ],
    child: MaterialApp(
      title: 'SchoolTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        // ✅ Ajoutez ScheduleRoutes.generate ici
        return ScheduleRoutes.generate(settings)
            // ?? ClassRoutes.generate(settings)   // vos autres routes
            // ?? GradeRoutes.generate(settings)
            ;
      },
      home: const YourHomePage(),
    ),
  );
}
```

> **Si vous utilisez GetIt (injection de dépendances) :**
> ```dart
> sl.registerFactory(() => ScheduleBloc(
>   repository: ScheduleRepositoryImpl(
>     dataSource: ScheduleRemoteDataSource(),
>   ),
> ));
> ```

---

## 🗺️ Étape 3 — Naviguer vers les emplois du temps

### Depuis le Dashboard ou le menu de navigation :

```dart
// Option A : Navigation directe (simple)
import 'features/schedules/presentation/pages/schedules_page.dart';

Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const SchedulesPage()),
);

// Option B : Route nommée (si vous utilisez onGenerateRoute)
import 'features/schedules/presentation/routes/schedule_routes.dart';

Navigator.pushNamed(context, ScheduleRoutes.list);
```

### Depuis le menu de navigation principal (bottom bar) :

```dart
// Ajoutez un onglet "Emplois du temps" dans votre BottomNavigationBar
BottomNavigationBarItem(
  icon: Icon(Icons.calendar_today_rounded),
  label: 'Emplois du temps',
),

// Et dans onTap, naviguez vers SchedulesPage :
case 3: // ou votre index
  return const SchedulesPage();
```

---

## 📊 Étape 4 — Carte statistique sur le Dashboard

Ajoutez `ScheduleStatCard` dans votre `DashboardPage` existante :

```dart
import 'features/schedules/presentation/widgets/schedule_stat_card.dart';
import 'features/schedules/presentation/routes/schedule_routes.dart';

// Dans votre grille de statistiques :
GridView(
  // ... votre configuration GridView existante
  children: [
    // Vos cartes existantes :
    EleveStatCard(...),
    ClassesStatCard(...),
    GradeStatCard(...),

    // ✅ AJOUTEZ CELLE-CI :
    ScheduleStatCard(
      onTap: () => Navigator.pushNamed(context, ScheduleRoutes.list),
    ),
  ],
)
```

> `ScheduleStatCard` se branche automatiquement sur le `ScheduleBloc`
> déjà fourni dans `MultiBlocProvider`. Aucune configuration supplémentaire.

---

## 🔥 Étape 5 — Structure Firestore

**Collection : `schedules`**

Exemple de document :
```json
{
  "classId": "classe_001",
  "className": "6ème A",
  "day": "Lundi",
  "subject": "Mathématiques",
  "teacher": "M. Dupont",
  "startTime": "08:00",
  "endTime": "10:00",
  "room": "Salle 12",
  "createdAt": <Timestamp>
}
```

> L'id du document est géré automatiquement par Firestore (`.add()`).
> Ne l'ajoutez pas manuellement dans les champs.

### Règles de sécurité Firestore recommandées :
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /schedules/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 🌍 Étape 6 — Locale française pour les dates (optionnel)

Dans `ScheduleDetailsPage`, la date de création est affichée en français.
Pour activer la locale française dans toute l'app :

```dart
// main.dart
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('fr_FR', null); // ← Ajoutez cette ligne
  runApp(const MyApp());
}
```

Si vous ne voulez pas de locale, dans `schedule_details_page.dart`,
remplacez :
```dart
createdDate = DateFormat("d MMM yyyy 'à' HH:mm", 'fr_FR').format(...);
```
par :
```dart
createdDate = DateFormat('dd/MM/yyyy HH:mm').format(...);
```

---

## 🚀 Flux de données complet

```
SchedulesPage
    │
    ├─ initState() → bloc.add(LoadSchedules())
    │
    ▼
ScheduleBloc._onLoad()
    │
    ├─ repository.getSchedules()
    │
    ▼
ScheduleRepositoryImpl.getSchedules()
    │
    ├─ dataSource.getSchedules()
    │
    ▼
ScheduleRemoteDataSource.getSchedules()
    │
    ├─ Firestore : collection('schedules').orderBy('day').get()
    │
    ▼  (résultat remonte dans l'autre sens)

ScheduleBloc émet ScheduleLoaded(allSchedules, filteredSchedules)
    │
    ▼
BlocBuilder reconstruit la liste groupée par jour ✓
```

---

## ❓ Questions fréquentes débutant

**Q : Pourquoi `id: ''` quand j'ajoute un créneau ?**
R : Firestore génère automatiquement un id unique via `.add()`.
   On ne le crée pas nous-mêmes.

**Q : Comment filtrer par classe dans le code ?**
R : `context.read<ScheduleBloc>().filterByClass('6ème A')`
   Pour tout afficher : `filterByClass(null)`

**Q : Comment récupérer le nombre total de créneaux ?**
R : `context.read<ScheduleBloc>().countTotal()`
   (Retourne 0 si les données ne sont pas encore chargées.)

**Q : Comment grouper les créneaux par jour ?**
R : `context.read<ScheduleBloc>().getSchedulesByDay()`
   Retourne `Map<String, List<ScheduleEntity>>` avec les jours comme clés.

**Q : L'AppBar du formulaire n'a pas de flèche retour sur iOS ?**
R : Le `leading: IconButton(...)` dans les pages d'ajout/modification
   la force. Sur iOS, Flutter l'ajoute aussi automatiquement.
