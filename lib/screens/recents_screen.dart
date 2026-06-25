import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:my_contact_list/screens/contact_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/local_contact.dart';

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

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m ${remainingSeconds}s";
    } else if (minutes > 0) {
      return "${minutes}m ${remainingSeconds}s";
    } else {
      return "${remainingSeconds}s";
    }
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

  Future<void> showContactDetails(CallLogEntry call) async {
    if (!await FlutterContacts.requestPermission()) return;

    final contacts = await FlutterContacts.getContacts(withProperties: true);

    Contact? matchedContact;

    for (final contact in contacts) {
      for (final phone in contact.phones) {
        String saved = phone.number.replaceAll(' ', '').replaceAll('-', '');

        String current = (call.number ?? '')
            .replaceAll(' ', '')
            .replaceAll('-', '');

        if (saved.contains(current) || current.contains(saved)) {
          matchedContact = contact;
          break;
        }
      }

      if (matchedContact != null) break;
    }

    if (matchedContact != null) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => ContactDetailsScreen(
      //       contact: LocalContact(
      //         name: matchedContact!.displayName,
      //         phone: matchedContact!.phones.isNotEmpty
      //             ? matchedContact!.phones.first.number
      //             : "",
      //       ),
      //     ),
      //   ),
      // );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF1E1E1E),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Call Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  title: Text(
                    "Number",
                    style: TextStyle(color: Colors.white70),
                  ),
                  subtitle: Text(
                    call.number ?? "Unknown",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                ListTile(
                  title: const Text(
                    "Type",
                    style: TextStyle(color: Colors.white70),
                  ),
                  subtitle: Text(
                    call.callType?.name ?? "Unknown",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                ListTile(
                  title: const Text(
                    "Duration",
                    style: TextStyle(color: Colors.white70),
                  ),
                  subtitle: Text(
                    "${call.duration ?? 0} sec",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Recent Calls",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : logs.isEmpty
          ? const Center(
              child: Text(
                "No Call History Found",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final call = logs[index];

                return Card(
                  color: const Color(0xFF1E1E1E),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(
                        (call.name?.isNotEmpty ?? false)
                            ? call.name![0].toUpperCase()
                            : "?",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    title: Text(
                      call.name ?? "Unknown",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          call.number ?? "No Number",
                          style: const TextStyle(color: Colors.white70),
                        ),

                        // Text(
                        //   call.callType?.name.toUpperCase() ?? "UNKNOWN",
                        //   style: const TextStyle(
                        //     color: Colors.white60,
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              call.timestamp!,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${formatDuration(call.duration ?? 0)}",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        IconButton(
                          iconSize: 20,
                          icon: getCallIcon(call.callType),
                          onPressed: () {
                            final number = call.number;
                            if (number != null && number.isNotEmpty) {
                              makeCall(number);
                            }
                          },
                        ),
                      ],
                    ),

                    onTap: () {
                      final number = call.number;
                      if (number != null && number.isNotEmpty) {
                        makeCall(number);
                      }
                    },

                    onLongPress: () {
                      showContactDetails(call);
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
      return const Icon(Icons.call_received, color: Colors.greenAccent);

    case CallType.outgoing:
      return const Icon(Icons.call_made, color: Colors.lightBlueAccent);

    case CallType.missed:
      return const Icon(Icons.call_missed, color: Colors.redAccent);

    default:
      return const Icon(Icons.call, color: Colors.white);
  }
}
