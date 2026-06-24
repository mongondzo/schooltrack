import 'package:flutter/material.dart';
import '../../domain/entities/parent.dart';

class ParentCard extends StatelessWidget {
  final Parent parent;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ParentCard({
    super.key,
    required this.parent,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,

        leading: const CircleAvatar(child: Icon(Icons.person)),

        title: Text("${parent.firstName} ${parent.lastName}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(parent.email), Text(parent.phone)],
        ),

        isThreeLine: true,

        // 🔹 Actions
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
