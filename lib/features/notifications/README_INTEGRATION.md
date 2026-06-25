# Intégration de la fonctionnalité Notifications au Dashboard

Ce zip contient toute la fonctionnalité **Notifications** (Data + Domain +
Presentation) ainsi que les fichiers d'intégration suivants :

- `lib/core/app_repositories.dart` → contient maintenant `gradeRepository`,
  `attendanceRepository` **et** `notificationRepository` (remplace
  l'ancienne version si tu l'as déjà)
- `lib/features/notifications/presentation/navigation/notification_navigation.dart`
  → fonctions de navigation prêtes à l'emploi
- `lib/features/dashboard/presentation/widgets/notifications_count_card.dart`
  → carte "Notifications envoyées" pour le Dashboard

## Étape 1 — Copier les fichiers

Place chaque fichier au même chemin dans ton projet. Si `app_repositories.dart`
existe déjà, remplace-le entièrement par la nouvelle version : elle contient
tout ce qu'il faut pour Grades, Attendance ET Notifications.

## Étape 2 — Ajouter la carte de stats sur le Dashboard

Dans ta `DashboardPage`, ajoute l'import :

```dart
import '../../dashboard/presentation/widgets/notifications_count_card.dart';
import '../../notifications/presentation/navigation/notification_navigation.dart';
```

Puis, dans ta grille de cartes :

```dart
NotificationsCountCard(
  onTap: () => openNotificationsPage(context),
),
```

## Étape 3 — Brancher une action rapide "Nouvelle notification" (optionnel)

Là où se trouvent tes actions rapides du Dashboard :

```dart
onTap: () => openAddNotificationPage(context),
```

## Étape 4 — Tester

1. Lance l'app.
2. La carte "Notifications" doit afficher le nombre total envoyé
   (ou "0" si aucune notification n'existe encore).
3. Un appui sur la carte ouvre la liste complète (NotificationsPage).
4. Tu peux créer, modifier, supprimer et consulter les détails d'une
   notification depuis cette page.

## Astuce

Comme pour Grades et Attendance, si tu veux que la carte se rafraîchisse
après l'envoi d'une notification, passe ta DashboardPage en
`StatefulWidget` et appelle `setState(() {})` au retour de
`Navigator.push`.
