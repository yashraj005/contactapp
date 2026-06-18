import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'contact_details_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final result = await FlutterContacts.getContacts(withProperties: true);

      setState(() {
        contacts = result;
        filteredContacts = result;
      });
    }
  }

  void searchContact(String query) {
    setState(() {
      filteredContacts = contacts.where((contact) {
        return contact.displayName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Contacts", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: searchContact,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Contact",
                hintStyle: const TextStyle(color: Colors.white54),

                prefixIcon: const Icon(Icons.search, color: Colors.white70),

                filled: true,
                fillColor: const Color(0xFF1E1E1E),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];

                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(
                        contact.displayName.isNotEmpty
                            ? contact.displayName[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    title: Text(
                      contact.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: contact.phones.isNotEmpty
                        ? Text(
                            contact.phones.first.number,
                            style: const TextStyle(color: Colors.white70),
                          )
                        : const Text(
                            "No Number",
                            style: TextStyle(color: Colors.white54),
                          ),

                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white54,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ContactDetailsScreen(contact: contact),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
