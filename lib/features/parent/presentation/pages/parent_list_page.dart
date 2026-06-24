import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/parent_bloc.dart';
import '../bloc/parent_event.dart';
import '../bloc/parent_state.dart';

class ParentListPage extends StatefulWidget {
  const ParentListPage({super.key});

  @override
  State<ParentListPage> createState() => _ParentListPageState();
}

class _ParentListPageState extends State<ParentListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ParentBloc>().add(LoadParents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parents")),

      body: BlocBuilder<ParentBloc, ParentState>(
        builder: (context, state) {
          // 🔵 LOADING
          if (state is ParentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🟢 SUCCESS (LISTE)
          if (state is ParentsLoaded) {
            final parents = state.parents;

            if (parents.isEmpty) {
              return const Center(child: Text("Aucun parent trouvé"));
            }

            return ListView.builder(
              itemCount: parents.length,
              itemBuilder: (context, index) {
                final parent = parents[index];

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text("${parent.firstName} ${parent.lastName}"),
                  subtitle: Text(parent.email),
                  trailing: Text(parent.phone),
                  onTap: () {
                    // 👉 futur navigation détails parent
                  },
                );
              },
            );
          }

          // 🔴 ERROR
          if (state is ParentError) {
            return Center(child: Text(state.message));
          }

          // ⚪ DEFAULT
          return const Center(child: Text("Aucun parent"));
        },
      ),
    );
  }
}
