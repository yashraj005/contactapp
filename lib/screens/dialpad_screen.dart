import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_details_screen.dart';

class DialPadScreen extends StatefulWidget {
  const DialPadScreen({super.key});

  @override
  State<DialPadScreen> createState() => _DialPadScreenState();
}

class _DialPadScreenState extends State<DialPadScreen> {
  String number = '';
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
    }
  }

  void findContact() {
    filteredContacts.clear();

    String entered = number.replaceAll(' ', '').replaceAll('-', '');

    if (entered.isEmpty) {
      setState(() {});
      return;
    }

    for (var contact in contacts) {
      for (var phone in contact.phones) {
        String phoneNumber = phone.number
            .replaceAll(' ', '')
            .replaceAll('-', '');

        if (phoneNumber.contains(entered)) {
          filteredContacts.add(contact);
          break;
        }
      }
    }

    setState(() {});
  }

  Future<void> makeCall() async {
    if (number.isEmpty) return;

    await launchUrl(Uri(scheme: 'tel', path: number));
  }

  void removeLastDigit() {
    if (number.isEmpty) return;

    setState(() {
      number = number.substring(0, number.length - 1);
      findContact();
    });
  }

  Widget dialButton(String numberValue, String letters) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        width: 65,
        height: 65,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            setState(() {
              number += numberValue;
              findContact();
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                numberValue,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (letters.isNotEmpty)
                Text(letters, style: const TextStyle(fontSize: 9)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Expanded(
              child: filteredContacts.isEmpty
                  ? const SizedBox()
                  : ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];

                        final phone = contact.phones.isNotEmpty
                            ? contact.phones.first.number
                            : "";

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              contact.displayName.isNotEmpty
                                  ? contact.displayName[0]
                                  : "?",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            phone,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () async {
                            await launchUrl(Uri(scheme: 'tel', path: phone));
                          },
                          onLongPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ContactDetailsScreen(contact: contact),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      number.isEmpty ? "Enter Number" : number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (number.isNotEmpty)
                    IconButton(
                      icon: const Icon(
                        Icons.backspace_outlined,
                        color: Colors.white,
                      ),
                      onPressed: removeLastDigit,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 300,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 1.8,
                children: [
                  dialButton('1', ''),
                  dialButton('2', 'ABC'),
                  dialButton('3', 'DEF'),
                  dialButton('4', 'GHI'),
                  dialButton('5', 'JKL'),
                  dialButton('6', 'MNO'),
                  dialButton('7', 'PQRS'),
                  dialButton('8', 'TUV'),
                  dialButton('9', 'WXYZ'),
                  dialButton('*', ''),
                  dialButton('0', '+'),
                  dialButton('#', ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
