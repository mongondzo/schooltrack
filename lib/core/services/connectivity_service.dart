// ===========================================================
// FICHIER : connectivity_service.dart
// CHEMIN  : core/services/connectivity_service.dart
//
// RÔLE : Vérifie si l'appareil a accès à Internet.
// Utilisé par SplashPage avant toute opération Firebase.
//
// Dépendance à ajouter dans pubspec.yaml :
//   connectivity_plus: ^5.0.0
// ===========================================================

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Instance du package connectivity_plus
  final Connectivity _connectivity = Connectivity();

  // ──────────────────────────────────────────────────────────
  // hasInternet() — Vérifie la connexion une seule fois
  //
  // Retourne true si l'appareil est connecté (WiFi, mobile,
  // Ethernet). Retourne false si aucune connexion détectée.
  //
  // Utilisation :
  //   final connected = await ConnectivityService().hasInternet();
  // ──────────────────────────────────────────────────────────
  Future<bool> hasInternet() async {
    // checkConnectivity() retourne une liste des types de
    // connexion actifs sur l'appareil
    final results = await _connectivity.checkConnectivity();

    // Si la liste contient autre chose que "none", il y a internet
    return results.any(
      (result) => result != ConnectivityResult.none,
    );
  }

  // ──────────────────────────────────────────────────────────
  // onConnectivityChanged — Stream des changements de connexion
  //
  // Émet automatiquement quand la connexion change.
  // Utile pour réagir en temps réel (WiFi coupé, 4G activée).
  //
  // Utilisation :
  //   ConnectivityService().onConnectivityChanged.listen((results) {
  //     final hasNet = results.any((r) => r != ConnectivityResult.none);
  //   });
  // ──────────────────────────────────────────────────────────
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}
