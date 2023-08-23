import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Docknest {
  Docknest({required this.ip, required this.name, id, required this.port})
      : id = id ?? uuid.v4();

  final String ip;
  final String name;
  final String port;
  final String id;

  @override
  bool operator ==(Object other) =>
      other is Docknest && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

enum DocknestField {
  ip('ip'),
  name('name'),
  port('port'),
  id('id');

  const DocknestField(this.str);

  final String str;
}
