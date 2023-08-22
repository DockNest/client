import 'package:docknest/models/add_docknest_screen.dart';
import 'package:docknest/models/docker/container.dart';
import 'package:docknest/providers/containers_provider.dart';
import 'package:docknest/screens/container_details_screen.dart';
import 'package:docknest/screens/logs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContainersList extends ConsumerStatefulWidget {
  const ContainersList({super.key, required this.docknest});

  final Docknest docknest;

  @override
  ConsumerState<ContainersList> createState() => _ContainersListState();
}

class _ContainersListState extends ConsumerState<ContainersList> {
  late final Future<void> _containersFuture;

  @override
  void initState() {
    super.initState();
    _containersFuture = ref
        .read(containersProvider.notifier)
        .loadAllContainers(widget.docknest.ip, widget.docknest.port);
  }

  @override
  Widget build(BuildContext context) {
    final containers = ref.watch(containersProvider).toList();

    if (containers.isEmpty) {
      return const Center(child: Text('No active containers '));
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: containers.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ContainerDetailsScreen(containers[index])));
                },
                title: Text('Name: ${containers[index].names[0]}'),
                subtitle: ContainerSubtitle(containers[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.list_alt),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LogsScreen(
                            container: containers[index],
                            docknest: widget.docknest),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        future: _containersFuture,
      ),
    );
  }
}

class ContainerSubtitle extends StatelessWidget {
  const ContainerSubtitle(this.container, {super.key});

  final DockerContainer container;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text('ID: ${container.id.substring(0, 8)}')),
        if (container.ports != null && container.ports!.isNotEmpty)
          Expanded(
            child: Text(
                'P: ${container.ports![0].publicPort}:${container.ports![0].privatePort}'),
          ),
        Expanded(child: Text(container.status))
      ],
    );
  }
}
