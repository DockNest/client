import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docknest/providers/docknests_provider.dart';
import 'package:docknest/screens/add_docknest_screen.dart';
import 'package:docknest/screens/containers_screen.dart';

class DocknestsList extends ConsumerStatefulWidget {
  const DocknestsList({super.key});

  @override
  ConsumerState<DocknestsList> createState() => _docknestsListState();
}

class _docknestsListState extends ConsumerState<DocknestsList> {
  late Future<void> _docknestsFuture;

  @override
  void initState() {
    super.initState();
    _docknestsFuture = ref.read(docknestsProvider.notifier).loadAlldocknests();
  }

  @override
  Widget build(BuildContext context) {
    final docknests = ref.watch(docknestsProvider).toList();

    if (docknests.isEmpty) {
      return const Center(child: Text('No docknests yet...'));
    }

    return Padding(
      padding: EdgeInsets.all(8),
      child: FutureBuilder(
        future: _docknestsFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return ListView.builder(
              itemCount: docknests.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(index),
                  onDismissed: (dir) => ref
                      .read(docknestsProvider.notifier)
                      .removedocknest(docknests[index]),
                  child: ListTile(
                    title: Text(docknests[index].name),
                    leading: Icon(Icons.directions_boat),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddDocknestScreen(
                                docknestToEdit: docknests[index]),
                          ));
                        },
                        icon: Icon(Icons.settings)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ContainersScreen(docknests[index]),
                      ));
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
