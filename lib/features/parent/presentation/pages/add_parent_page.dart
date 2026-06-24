import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/parent.dart';
import '../bloc/parent_bloc.dart';
import '../bloc/parent_event.dart';

class AddParentPage extends StatefulWidget {
  const AddParentPage({super.key});

  @override
  State<AddParentPage> createState() => _AddParentPageState();
}

class _AddParentPageState extends State<AddParentPage> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  void submit() {
    if (_formKey.currentState!.validate()) {
      final parent = Parent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );

      context.read<ParentBloc>().add(AddParentEvent(parent));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un parent")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "Prénom"),
                validator: (value) =>
                    value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (value) =>
                    value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Téléphone"),
                validator: (value) =>
                    value!.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: submit, child: const Text("Ajouter")),
            ],
          ),
        ),
      ),
    );
  }
}
