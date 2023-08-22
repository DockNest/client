import 'package:flutter/material.dart';

class LogsList extends StatelessWidget {
  const LogsList(this.logs, {super.key});
  final Future<List<String>> logs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: logs,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(border: Border.all(width: 0.2)),
              child: ListTile(
                title: Text(snapshot.data![index]),
              ),
            );
          },
        );
      },
    );
  }
}
