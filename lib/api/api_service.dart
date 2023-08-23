import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:docknest/models/docker/container.dart';

class ApiService {
  final _client = http.Client();
  static const path = "docknest";

  Future<bool> testConnection(String ip, String port) async {
    try {
      var response = await _client.post(
        Uri.http('$ip:$port', path),
        body: convert.jsonEncode({"test": true}),
      );

      if (response.statusCode != 200) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getLogs(
      String ip, port, String containerId, int tail) async {
    try {
      var response = await _client.post(
        Uri.http('$ip:$port', path),
        body: convert.jsonEncode({
          "command": "run",
          "dockerCmd": "logs",
          "containerId": containerId,
          "limit": tail,
        }),
      );

      if (response.statusCode == 200) {
        return List<String>.from(convert.jsonDecode(response.body));
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<DockerContainer>> getContainers(String ip, port) async {
    try {
      var response = await _client.post(
        Uri.http('$ip:$port', path),
        body: convert.jsonEncode({"command": "run", "dockerCmd": "ps"}),
      );

      if (response.statusCode == 200) {
        try {
          List<dynamic> jsonArray = convert.jsonDecode(response.body);

          return jsonArray.map((e) => DockerContainer.fromJson(e)).toList();
        } catch (e) {
          return [];
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
