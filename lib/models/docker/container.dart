import 'package:json_annotation/json_annotation.dart';

part 'container.g.dart';

@JsonSerializable()
class DockerContainer {
  @JsonKey(name: 'Id')
  String id;

  @JsonKey(name: 'Names')
  List<String> names;

  @JsonKey(name: 'Image')
  String image;

  @JsonKey(name: 'ImageID')
  String imageId;

  @JsonKey(name: 'Command')
  String command;

  @JsonKey(name: 'Created')
  int created;

  @JsonKey(name: 'Ports')
  List<Port>? ports;

  @JsonKey(name: 'Status')
  String status;

  DockerContainer({
    required this.id,
    required this.names,
    required this.image,
    required this.imageId,
    required this.command,
    required this.created,
    required this.status,
    required this.ports,
  });

  factory DockerContainer.fromJson(Map<String, dynamic> json) =>
      _$ContainerFromJson(json);

  Map<String, dynamic> toJson() => _$ContainerToJson(this);
}

@JsonSerializable()
class Port {
  @JsonKey(name: 'IP')
  String ip;

  @JsonKey(name: 'PrivatePort')
  int privatePort;

  @JsonKey(name: 'PublicPort')
  int publicPort;

  @JsonKey(name: 'Type')
  String type;

  Port({
    required this.ip,
    required this.privatePort,
    required this.publicPort,
    required this.type,
  });

  factory Port.fromJson(Map<String, dynamic> json) => _$PortFromJson(json);

  Map<String, dynamic> toJson() => _$PortToJson(this);
}
