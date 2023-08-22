import 'package:flutter/material.dart';
import 'package:docknest/api/api_service.dart';
import 'package:docknest/models/docker/container.dart';
import 'package:docknest/models/add_docknest_screen.dart';
import 'package:docknest/widgets/containers_list.dart';
import 'package:docknest/widgets/log_settings.dart';
import 'package:docknest/widgets/logs_list.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen(
      {super.key, required this.container, required this.docknest});

  final DockerContainer container;
  final Docknest docknest;

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController limitController = TextEditingController();
  var _fetchingLogs = false;
  Future<List<String>>? logs;

  @override
  void initState() {
    super.initState();
    _fetchLogs(16);
  }

  @override
  void dispose() {
    limitController.dispose();
    super.dispose();
  }

  void _fetchLogs(int limit) {
    setState(() {
      _fetchingLogs = true;
      logs = _apiService.getLogs(
        widget.docknest.ip,
        widget.docknest.port,
        widget.container.id,
        limit,
      ).whenComplete(() {
        setState(() {
          _fetchingLogs = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.container.names[0]} logs',
        ),
      ),
      body: Column(
        children: [
          LogSettings(
            limitController: limitController,
            onRefresh: (limit) => _fetchLogs(limit),
            fetchingLogs: _fetchingLogs,
          ),
          Expanded(
            child: logs == null
                ? const CircularProgressIndicator()
                : LogsList(logs!),
          ),
        ],
      ),
    );
  }
}
