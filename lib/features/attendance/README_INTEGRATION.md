# Intégration de la fonctionnalité Attendance au Dashboard

Ce zip contient toute la fonctionnalité **Attendance** (Data + Domain +
Presentation) ainsi que les fichiers d'intégration suivants :

- `lib/core/app_repositories.dart` → contient maintenant `gradeRepository`
  **et** `attendanceRepository` (remplace l'ancienne version si tu l'as déjà)
- `lib/features/attendance/presentation/navigation/attendance_navigation.dart`
  → fonctions de navigation prêtes à l'emploi
- `lib/features/dashboard/presentation/widgets/attendance_stats_card.dart`
  → carte "Présences" (présents / absents / retards) pour le Dashboard

## Étape 1 — Copier les fichiers

Place chaque fichier au même chemin dans ton projet. Si un fichier existe
déjà (`app_repositories.dart`), remplace-le entièrement par la nouvelle
version : elle contient tout ce qu'il faut pour Grades ET Attendance.

## Étape 2 — Ajouter les dépendances

Vérifie que `cloud_firestore` et `flutter_bloc` sont bien dans ton
`pubspec.yaml` (déjà nécessaires pour Grades, donc probablement déjà fait).

## Étape 3 — Ajouter la carte de stats sur le Dashboard

Dans ta `DashboardPage`, ajoute l'import :

```dart
import '../../dashboard/presentation/widgets/attendance_stats_card.dart';
import '../../attendance/presentation/navigation/attendance_navigation.dart';
```

Puis, dans ta grille de cartes (à côté de "Élèves", "Classes", "Notes"...) :

```dart
AttendanceStatsCard(
  onTap: () => openAttendancePage(context),
),
```

## Étape 4 — Brancher une action rapide "Nouvelle présence" (optionnel)

Là où se trouvent tes actions rapides du Dashboard :

```dart
onTap: () => openAddAttendancePage(context),
```

## Étape 5 — Tester

1. Lance l'app.
2. La carte "Présences" doit afficher les compteurs Présents / Absents / Retards
   (ou "0" partout si aucune présence n'est encore enregistrée).
3. Un appui sur la carte ouvre la liste complète des présences (AttendancePage).
4. Dans la liste, le bouton "⋮" sur chaque carte permet de marquer
   rapidement un élève présent / absent / en retard, sans ouvrir le formulaire.

## Astuce

Pour que la carte de stats se rafraîchisse après un ajout/modification,
fais comme pour Grades : passe ta DashboardPage en `StatefulWidget` et
appelle `setState(() {})` au retour de `Navigator.push`.
