import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_contact_list/model/local_contact.dart';
import 'package:my_contact_list/screens/CreateNewContact.dart';
import 'package:my_contact_list/screens/contact_details_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<LocalContact> contacts = [];
  List<LocalContact> filteredContacts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeContacts();
  }

  Future<void> initializeContacts() async {
    final box = Hive.box('contactsBox');

    if (box.containsKey('contacts')) {
      await loadContactsFromHive();
    } else {
      await syncContactsFromPhone();
    }
  }

  Future<void> syncContactsFromPhone() async {
    if (await FlutterContacts.requestPermission()) {
      final result = await FlutterContacts.getContacts(withProperties: true);

      await saveContactsToLocal(result);

      await loadContactsFromHive();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveContactsToLocal(List<Contact> contacts) async {
    final box = Hive.box('contactsBox');

    List<Map<String, dynamic>> data = contacts.map((c) {
      return LocalContact(
        name: c.displayName,
        phone: c.phones.isNotEmpty ? c.phones.first.number : '',
      ).toMap();
    }).toList();

    await box.put('contacts', data);

    print("Saved ${data.length} contacts");
  }

  Future<void> loadContactsFromHive() async {
    final box = Hive.box('contactsBox');

    final data = box.get('contacts', defaultValue: []);
    List<LocalContact> loadedContacts = (data as List)
        .map((item) => LocalContact.fromMap(item))
        .toList();

    setState(() {
      contacts = loadedContacts;
      filteredContacts = loadedContacts;
      isLoading = false;
    });

    print("Loaded ${loadedContacts.length} contacts from Hive");
  }

  void searchContact(String query) {
    setState(() {
      filteredContacts = contacts.where((contact) {
        return contact.name.toLowerCase().contains(query.toLowerCase());
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: searchContact,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search Contact",
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.only(right: 20, left: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      bool added = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Createnewcontact(),
                        ),
                      );
                      if (added) {
                        loadContactsFromHive();
                      }
                    },
                    child: Row(
                      children: [Icon(Icons.add), Text("Create new Contact")],
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
                              contact.name.isNotEmpty
                                  ? contact.name[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          title: Text(
                            contact.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          subtitle: Text(
                            contact.phone.isNotEmpty
                                ? contact.phone
                                : "No Number",
                            style: const TextStyle(color: Colors.white70),
                          ),

                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.white54,
                          ),
                          onLongPress: () async {
                            final selected = await showMenu(
                              context: context,
                              position: const RelativeRect.fromLTRB(
                                100,
                                300,
                                0,
                                0,
                              ),
                              items: const [
                                PopupMenuItem(
                                  value: 'copy',
                                  child: Row(
                                    children: [
                                      Icon(Icons.copy, color: Colors.grey),
                                      SizedBox(width: 10),
                                      Text('Copy number'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 10),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 10),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                            );

                            if (selected == 'copy') {
                              // copy code
                              Clipboard.setData(
                                ClipboardData(text: contact.phone),
                              );
                            }
                            if (selected == 'edit') {
                              // Edit code
                            }

                            if (selected == 'delete') {
                              // Delete code
                            }
                          },
                          onTap: () {
                            // later you can pass LocalContact
                            // print(contact.name);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
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
