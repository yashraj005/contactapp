import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:my_contact_list/screens/EditScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:my_contact_list/db/app_database.dart' as db;

class ContactDetailsScreen extends StatefulWidget {
  final db.Contact contact;

  ContactDetailsScreen({super.key, required this.contact});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  final database = db.AppDatabase();

  List<CallLogEntry> callHistory = [];
  bool loadingHistory = true;

  @override
  void initState() {
    super.initState();
    loadCallHistory();
  }

  Future<void> callNumber(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);

    await launchUrl(uri);
  }

  Future<void> sendMessage(String number) async {
    final Uri uri = Uri(scheme: 'sms', path: number);

    await launchUrl(uri);
  }

  Future<void> openWhatsApp(String number) async {
    String cleaned = number.replaceAll(RegExp(r'[^0-9]'), '');

    if (!cleaned.startsWith('91')) {
      cleaned = '91$cleaned';
    }

    final Uri uri = Uri.parse('https://wa.me/$cleaned');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> loadCallHistory() async {
    if (await Permission.phone.request().isGranted) {
      final logs = await CallLog.get();

      String contactNumber = widget.contact.mobileNumber.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );

      List<CallLogEntry> filtered = [];

      for (final log in logs) {
        String logNumber = (log.number ?? '').replaceAll(RegExp(r'[^0-9]'), '');

        if (contactNumber.isNotEmpty && logNumber.endsWith(contactNumber)) {
          filtered.add(log);
        }
      }

      setState(() {
        callHistory = filtered;
        loadingHistory = false;
      });
    } else {
      setState(() {
        loadingHistory = false;
      });
    }
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return "$hours h $minutes m $remainingSeconds s";
    }

    if (minutes > 0) {
      return "$minutes m $remainingSeconds s";
    }

    return "$remainingSeconds s";
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
        return const Icon(Icons.call, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    String number = "";

    if (widget.contact.mobileNumber.isNotEmpty)
      number = widget.contact.mobileNumber;
    else if (widget.contact.workNumber.isNotEmpty)
      number = widget.contact.workNumber;
    else if (widget.contact.phoneNumber.isNotEmpty)
      number = widget.contact.phoneNumber;
    else
      number = widget.contact.mainNumber;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          widget.contact.firstname,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.deepPurple,

              child: Text(
                widget.contact.firstname.isNotEmpty
                    ? widget.contact.firstname[0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "${widget.contact.firstname + " " + widget.contact.lastname}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => callNumber(number),
                              icon: const Icon(Icons.call, color: Colors.green),
                            ),
                            const Text(
                              "Call",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            IconButton(
                              onPressed: () => sendMessage(number),
                              icon: const Icon(
                                Icons.message,
                                color: Colors.orange,
                              ),
                            ),
                            const Text(
                              "SMS",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            IconButton(
                              onPressed: () => openWhatsApp(number),
                              icon: Image.asset(
                                height: 26,
                                './assets/icons/whatsapp_icon.png',
                              ),
                            ),
                            const Text(
                              "WhatsApp",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            if (widget.contact.email != "")
              ListTile(
                title: Text(
                  widget.contact.email,
                  style: TextStyle(color: Colors.blue),
                ),
                subtitle: Text("Email"),
                trailing: IconButton(
                  onPressed: () async {
                    final url = Uri(
                      scheme: 'mailto',
                      path: widget.contact.email,
                    );
                    await launchUrl(url);
                  },
                  icon: Icon(Icons.email_outlined, color: Colors.white),
                ),
              ),
            Column(
              children: [
                if (widget.contact.workNumber != "")
                  ListTile(
                    subtitle: Text("Work"),
                    title: Text(
                      widget.contact.workNumber,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final url = Uri(
                          scheme: 'tel',
                          path: widget.contact.workNumber,
                        );
                        await launchUrl(url);
                      },
                      icon: Icon(Icons.call, color: Colors.white),
                    ),
                  ),
                if (widget.contact.phoneNumber != "")
                  ListTile(
                    title: Text(
                      widget.contact.phoneNumber,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri(scheme: 'tel', path: widget.contact.phoneNumber),
                        );
                      },
                      icon: Icon(Icons.call, color: Colors.white),
                    ),
                  ),
                if (widget.contact.mainNumber.isNotEmpty)
                  ListTile(
                    title: Text(
                      widget.contact.mainNumber,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri(scheme: 'tel', path: widget.contact.mainNumber),
                        );
                      },
                      icon: Icon(Icons.call, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Calls",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            loadingHistory
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  )
                : callHistory.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No Call History Found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : Column(
                    children: callHistory
                        .take(15)
                        .map(
                          (call) => Card(
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
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),

                                  Text(
                                    call.timestamp != null
                                        ? DateFormat(
                                            'dd MMM yyyy, hh:mm a',
                                          ).format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              call.timestamp!,
                                            ),
                                          )
                                        : "Unknown Date",
                                    style: const TextStyle(
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
