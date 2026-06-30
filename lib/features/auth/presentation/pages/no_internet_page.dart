// ===========================================================
// FICHIER : no_internet_page.dart
// CHEMIN  : features/auth/presentation/pages/no_internet_page.dart
//
// RÔLE : Affiché par SplashPage quand aucune connexion
// Internet n'est détectée. Propose de réessayer.
// ===========================================================

import 'package:flutter/material.dart';

import '../../../../core/services/connectivity_service.dart';
import 'splash_page.dart';

class NoInternetPage extends StatefulWidget {
  static const String routeName = '/no-internet';

  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isChecking = false;

  // ── Réessaie la connexion et retourne au Splash si OK ─────
  Future<void> _retry() async {
    setState(() => _isChecking = true);

    // Petit délai pour que l'animation soit visible
    await Future.delayed(const Duration(milliseconds: 800));

    final hasInternet = await _connectivityService.hasInternet();

    if (!mounted) return;

    if (hasInternet) {
      // Connexion rétablie → retour au Splash qui relancera
      // toute la séquence de vérification
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const SplashPage()));
    } else {
      // Toujours pas de connexion
      setState(() => _isChecking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Toujours pas de connexion...'),
          backgroundColor: const Color.fromARGB(255, 0, 45, 245),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // ── Illustration ──────────────────────────────
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 224, 229, 255),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 60,
                  color: Colors.blue.shade400,
                ),
              ),

              const SizedBox(height: 32),

              // ── Titre ─────────────────────────────────────
              const Text(
                'Pas de connexion',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 12),

              // ── Description ───────────────────────────────
              Text(
                'BolandiApp nécessite une connexion\nInternet pour fonctionner.\n\nVérifiez votre WiFi ou vos données mobiles.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade500,
                  height: 1.6,
                ),
              ),

              const Spacer(),

              // ── Bouton Réessayer ──────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isChecking ? null : _retry,
                  icon: _isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.refresh_rounded),
                  label: Text(
                    _isChecking ? 'Vérification...' : 'Réessayer',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
