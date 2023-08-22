import 'package:flutter/material.dart';
import 'package:docknest/models/docker/container.dart';

class ContainerDetailsScreen extends StatelessWidget {
  const ContainerDetailsScreen(this.container, {super.key});

  final DockerContainer container;

  @override
  Widget build(BuildContext context) {

    String createPorts() {
      String ports =  '';
      if(container.ports != null && container.ports!.isNotEmpty) {
        for(Port port in container.ports!) {
          ports += '${port.publicPort}:${port.privatePort},';
        }
      }

      return ports;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Container: ${container.names[0]}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Id: ${container.id.substring(0,12)}'),
            SizedBox(height: 12,),
            Text('Image name: ${container.image}'),
            SizedBox(height: 12,),
            Text('Image id: ${container.imageId.split(":")[1].substring(0,12)}'),
            SizedBox(height: 12,),
            if(container.ports != null && container.ports!.isNotEmpty)
            Text('Ports: ${createPorts()}'),
            SizedBox(height: 12,),
            Text('Status: ${container.status}'),
            SizedBox(height: 12,),
            Text('Created: ${DateTime.fromMillisecondsSinceEpoch(container.created * 1000)}'),
            SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }
}
