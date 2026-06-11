import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticatedState) {
            final user = state.user;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: user.imageUrl.isNotEmpty
                        ? NetworkImage(user.imageUrl)
                        : null,
                    child: user.imageUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Nom : ${user.name}",
                    style: const TextStyle(fontSize: 18),
                  ),

                  Text("Email : ${user.email}"),

                  Text("ID : ${user.id}"),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
