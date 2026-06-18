import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;

  const ContactDetailsScreen({super.key, required this.contact});

  Future<void> callNumber(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);

    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final phones = contact.phones;
    final emails = contact.emails;

    return Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                contact.displayName.isNotEmpty ? contact.displayName[0] : "?",
                style: const TextStyle(fontSize: 40),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              contact.displayName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Phone Numbers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            ...phones.map(
              (phone) => Card(
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(phone.number),
                  trailing: IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () {
                      callNumber(phone.number);
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Emails",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            ...emails.map(
              (email) => Card(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(email.address),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
