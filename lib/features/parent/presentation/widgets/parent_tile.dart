import 'package:flutter/material.dart';
import '../../domain/entities/parent.dart';

class ParentTile extends StatelessWidget {
  final Parent parent;
  final VoidCallback onTap;

  const ParentTile({super.key, required this.parent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,

      leading: const CircleAvatar(child: Icon(Icons.person)),

      title: Text("${parent.firstName} ${parent.lastName}"),
      subtitle: Text(parent.email),

      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
