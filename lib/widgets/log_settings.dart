import 'package:flutter/material.dart';

class LogSettings extends StatelessWidget {
  const LogSettings(
      {super.key,
      required this.onRefresh,
      required this.limitController,
      required this.fetchingLogs});

  final TextEditingController limitController;
  final Function(int limit) onRefresh;
  final bool fetchingLogs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 64,
            child: TextField(
              controller: limitController,
              maxLength: 5,
              decoration: const InputDecoration(labelText: "Limit"),
              keyboardType: TextInputType.number,
            ),
          ),
          IconButton(
            onPressed: fetchingLogs
                ? null
                : () {
                    int limit = int.tryParse(limitController.text) ?? 16;
                    onRefresh(limit > 4096 ? 4096 : limit);
                  },
            icon: const Icon(
              Icons.refresh,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
