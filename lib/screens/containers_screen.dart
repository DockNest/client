import 'package:docknest/models/add_docknest_screen.dart';
import 'package:flutter/material.dart';
import 'package:docknest/models/add_docknest_screen.dart';
import 'package:docknest/widgets/containers_list.dart';

class ContainersScreen extends StatelessWidget {
  const ContainersScreen(this.docknest, {super.key});

  final Docknest docknest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${docknest.name} containers',
        ),
      ),
      body: ContainersList(
        docknest: docknest,
      ),
    );
  }
}
