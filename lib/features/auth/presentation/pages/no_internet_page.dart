import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooltrack/features/auth/presentation/bloc/auth_bloc.dart';

import '../bloc/auth_event.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80),
            SizedBox(height: 20),
            Text("Aucune connexion Internet"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthCheckConnectionEvent());
              },
              child: Text("Réessayer erreur de connection"),
            ),
          ],
        ),
      ),
    );
  }
}
