import 'package:docknest/api/api_service.dart';
import 'package:docknest/models/docker/container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ContainersNotifier extends StateNotifier<Set<DockerContainer>> {
  ContainersNotifier() : super(<DockerContainer>{});

  final _apiService = ApiService();

  Future<void> loadAllContainers(String ip, String port) async {
    final containers = await _apiService.getContainers(ip, port);

    state = {...containers};
  }
}

final containersProvider =
StateNotifierProvider<ContainersNotifier, Set<DockerContainer>>(
        (ref) => ContainersNotifier());
