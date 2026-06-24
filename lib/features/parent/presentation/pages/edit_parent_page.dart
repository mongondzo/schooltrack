import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/parent.dart';
import '../bloc/parent_bloc.dart';
import '../bloc/parent_event.dart';

class EditParentPage extends StatefulWidget {
  final Parent parent;

  const EditParentPage({super.key, required this.parent});

  @override
  State<EditParentPage> createState() => _EditParentPageState();
}

class _EditParentPageState extends State<EditParentPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(text: widget.parent.firstName);
    lastNameController = TextEditingController(text: widget.parent.lastName);
    emailController = TextEditingController(text: widget.parent.email);
    phoneController = TextEditingController(text: widget.parent.phone);
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      final updatedParent = Parent(
        id: widget.parent.id, // IMPORTANT: garder le même ID
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );

      context.read<ParentBloc>().add(UpdateParentEvent(updatedParent));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier parent")),
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
              ElevatedButton(onPressed: submit, child: const Text("Modifier")),
            ],
          ),
        ),
      ),
    );
  }
}
