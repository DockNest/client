// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DockerContainer _$ContainerFromJson(Map<String, dynamic> json) => DockerContainer(
      id: json['Id'] as String,
      names: (json['Names'] as List<dynamic>).map((e) => e as String).toList(),
      image: json['Image'] as String,
      imageId: json['ImageID'] as String,
      command: json['Command'] as String,
      created: json['Created'] as int,
      status: json['Status'] as String,
      ports: (json['Ports'] as List<dynamic>)
          .map((e) => Port.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContainerToJson(DockerContainer instance) => <String, dynamic>{
      'Id': instance.id,
      'Names': instance.names,
      'Image': instance.image,
      'ImageID': instance.imageId,
      'Command': instance.command,
      'Created': instance.created,
      'Ports': instance.ports,
      'Status': instance.status,
    };

Port _$PortFromJson(Map<String, dynamic> json) => Port(
      ip: json['IP'] as String,
      privatePort: json['PrivatePort'] as int,
      publicPort: json['PublicPort'] as int,
      type: json['Type'] as String,
    );

Map<String, dynamic> _$PortToJson(Port instance) => <String, dynamic>{
      'IP': instance.ip,
      'PrivatePort': instance.privatePort,
      'PublicPort': instance.publicPort,
      'Type': instance.type,
    };
