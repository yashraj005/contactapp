import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen> {
  List<CallLogEntry> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<void> loadLogs() async {
    try {
      PermissionStatus status = await Permission.phone.request();

      if (status.isGranted) {
        Iterable<CallLogEntry> entries = await CallLog.get();

        setState(() {
          logs = entries.toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading call logs: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> makeCall(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Calls")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : logs.isEmpty
          ? const Center(
              child: Text(
                "No Call History Found",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final call = logs[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        (call.name?.isNotEmpty ?? false)
                            ? call.name![0].toUpperCase()
                            : "?",
                      ),
                    ),

                    title: Text(
                      call.name ?? "Unknown",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(call.number ?? "No Number"),

                        Text(
                          call.callType?.name.toUpperCase() ?? "UNKNOWN",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "Duration: ${call.duration ?? 0} sec",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),

                    trailing: IconButton(
                      icon: getCallIcon(call.callType),
                      onPressed: () {
                        final number = call.number;

                        if (number != null && number.isNotEmpty) {
                          makeCall(number);
                        }
                      },
                    ),

                    onTap: () {
                      final number = call.number;

                      if (number != null && number.isNotEmpty) {
                        makeCall(number);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}

Widget getCallIcon(CallType? type) {
  switch (type) {
    case CallType.incoming:
      return const Icon(Icons.call_received, color: Colors.green);

    case CallType.outgoing:
      return const Icon(Icons.call_made, color: Colors.blue);

    case CallType.missed:
      return const Icon(Icons.call_missed, color: Colors.red);

    default:
      return const Icon(Icons.call);
  }
}
