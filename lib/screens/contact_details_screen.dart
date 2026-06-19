import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class ContactDetailsScreen extends StatefulWidget {
  final Contact contact;

  const ContactDetailsScreen({super.key, required this.contact});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  List<CallLogEntry> callHistory = [];
  bool loadingHistory = true;
  Future<void> callNumber(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);

    await launchUrl(uri);
  }

  Future<void> sendMessage(String number) async {
    final Uri uri = Uri(scheme: 'sms', path: number);

    await launchUrl(uri);
  }

  @override
  void initState() {
    super.initState();
    loadCallHistory();
  }

  Future<void> loadCallHistory() async {
    if (await Permission.phone.request().isGranted) {
      final logs = await CallLog.get();

      List<CallLogEntry> filtered = [];

      for (final log in logs) {
        for (final phone in widget.contact.phones) {
          String contactNumber = phone.number.replaceAll(RegExp(r'[^0-9]'), '');

          String logNumber = (log.number ?? '').replaceAll(
            RegExp(r'[^0-9]'),
            '',
          );

          if (contactNumber.isNotEmpty && logNumber.endsWith(contactNumber)) {
            filtered.add(log);
          }
        }
      }

      setState(() {
        callHistory = filtered;
        loadingHistory = false;
      });
    }
  }

  Future<void> openWhatsApp(String number) async {
    String cleaned = number.replaceAll(RegExp(r'[^0-9]'), '');

    if (!cleaned.startsWith('91')) {
      cleaned = '91$cleaned';
    }

    final Uri uri = Uri.parse('https://wa.me/$cleaned');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
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

  @override
  Widget build(BuildContext context) {
    final phones = widget.contact.phones;
    final emails = widget.contact.emails;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          widget.contact.displayName,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.deepPurple,
              child: Text(
                widget.contact.displayName.isNotEmpty
                    ? widget.contact.displayName[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.contact.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Phone Numbers",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...phones.map(
              (phone) => Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phone.number,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              // Video Call
                              openWhatsApp(phone.number);
                            },
                            child: const Column(
                              children: [
                                Icon(Icons.videocam, color: Colors.blueAccent),
                                SizedBox(height: 4),
                                Text(
                                  "Video",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              sendMessage(phone.number);
                            },
                            child: const Column(
                              children: [
                                Icon(Icons.message, color: Colors.orangeAccent),
                                SizedBox(height: 4),
                                Text(
                                  "Message",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              openWhatsApp(phone.number);
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/icons/whatsapp_icon.png',
                                  height: 26,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "WhatsApp",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              callNumber(phone.number);
                            },
                            child: const Column(
                              children: [
                                Icon(Icons.call, color: Colors.greenAccent),
                                SizedBox(height: 4),
                                Text(
                                  "Call",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Emails",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...emails.map(
              (email) => Card(
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.deepPurple),
                  title: Text(
                    email.address,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Call History",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 10),
            loadingHistory
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  )
                : callHistory.isEmpty
                ? const Text(
                    "No Call History",
                    style: TextStyle(color: Colors.white70),
                  )
                : Column(
                    children: callHistory.take(10).map((call) {
                      return Card(
                        color: const Color(0xFF1E1E1E),
                        child: ListTile(
                          leading: getCallIcon(call.callType),

                          title: Text(
                            call.number ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Duration: ${formatDuration(call.duration ?? 0)}",
                                style: const TextStyle(color: Colors.white70),
                              ),

                              Text(
                                call.timestamp != null
                                    ? DateFormat('dd MMM yyyy, hh:mm a').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          call.timestamp!,
                                        ),
                                      )
                                    : "Unknown Date",
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
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
