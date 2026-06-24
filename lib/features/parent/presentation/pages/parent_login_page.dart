import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/parent_bloc.dart';
import '../bloc/parent_event.dart';
import '../bloc/parent_state.dart';

class ParentLoginPage extends StatefulWidget {
  const ParentLoginPage({super.key});

  @override
  State<ParentLoginPage> createState() => _ParentLoginPageState();
}

class _ParentLoginPageState extends State<ParentLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    context.read<ParentBloc>().add(
      LoginParentEvent(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion Parent")),
      body: BlocConsumer<ParentBloc, ParentState>(
        listener: (context, state) {
          if (state is ParentLoggedIn) {
            Navigator.pushReplacementNamed(context, "/dashboard");
          }

          if (state is ParentError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Mot de passe"),
                ),
                const SizedBox(height: 20),

                if (state is ParentLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: login,
                    child: const Text("Se connecter"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
