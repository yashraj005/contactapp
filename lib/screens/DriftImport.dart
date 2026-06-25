import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:my_contact_list/db/app_database.dart' as db;
import 'package:my_contact_list/db/tables/contacts_table.dart';
import 'package:my_contact_list/screens/CreateNewContact.dart';
import 'package:my_contact_list/screens/EditScreen.dart';
import 'package:my_contact_list/screens/contact_details_screen.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:share_plus/share_plus.dart';

class Driftimport extends StatefulWidget {
  const Driftimport({super.key});

  @override
  State<Driftimport> createState() => _DriftimportState();
}

class _DriftimportState extends State<Driftimport> {
  final database = db.AppDatabase();

  bool isImporting = false;
  double progress = 0;

  List<db.Contact> contactsList = [];
  List<db.Contact> filteredcontactsList = [];
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    contactsList = await database.getAllContacts();

    // Alphabetical order (A-Z)
    contactsList.sort(
      (a, b) => a.firstname.toString().toLowerCase().compareTo(
        b.firstname.toString().toLowerCase(),
      ),
    );

    if (searchQuery.isNotEmpty) {
      contactsList = contactsList.where((contact) {
        return contact.firstname.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
      }).toList();
    }

    print("Contacts loaded: ${contactsList.length}");

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> importContacts() async {
    try {
      if (!await fc.FlutterContacts.requestPermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contacts permission denied")),
        );
        return;
      }

      final phoneContacts = await fc.FlutterContacts.getContacts(
        withProperties: true,
      );
      print("Phone contacts found: ${phoneContacts.length}");

      final total = phoneContacts.length;

      if (total == 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No contacts found")));
        return;
      }

      setState(() {
        isImporting = true;
        progress = 0;
      });

      await database.deleteAllContacts();

      for (int i = 0; i < total; i++) {
        final contact = phoneContacts[i];

        try {
          String mobile = '';
          String work = '';
          String home = '';
          String main = '';

          if (contact.phones.isNotEmpty) {
            mobile = contact.phones.first.number;
          }

          final name = contact.displayName.trim();

          await database.insertToDb(
            name.isEmpty ? "Unknown" : name,
            '', // lastname
            '', // email
            mobile,
            work,
            home,
            main,
            DateTime.now(),
            '', // address
          );

          print("Imported: $name");
        } catch (e) {
          print("Failed to import ${contact.displayName}");
          print(e);
        }

        if (mounted) {
          setState(() {
            progress = (i + 1) / total;
          });
        }
      }

      await loadContacts();

      if (mounted) {
        setState(() {
          isImporting = false;
          progress = 1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Imported ${contactsList.length} contacts successfully",
            ),
          ),
        );
      }
    } catch (e) {
      print("IMPORT ERROR: $e");

      if (mounted) {
        setState(() {
          isImporting = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Import failed: $e")));
      }
    }
  }

  Future<void> deleteContacts() async {
    await database.deleteAllContacts();
    await loadContacts();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("All contacts deleted")));
    }
  }

  Future<void> exportContactsToExcel() async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Contacts'];

      sheet.appendRow([
        TextCellValue("Name"),
        TextCellValue("Country Code"),
        TextCellValue("Phone"),
      ]);

      for (final contact in contactsList) {
        String countryCode = '+91';
        String mobileNumber = contact.mobileNumber;

        try {
          final parsed = PhoneNumber.parse(mobileNumber);

          countryCode = parsed.countryCode;
          mobileNumber = parsed.nsn;
        } catch (e) {
          print('Failed to parse: ${contact.mobileNumber}');
        }

        sheet.appendRow([
          TextCellValue(contact.firstname),
          TextCellValue(countryCode),
          TextCellValue(mobileNumber),
        ]);
      }

      final bytes = excel.encode();
      if (bytes == null) return;

      final downloadDir = Directory('/storage/emulated/0/Download');
      final file = File('${downloadDir.path}/contacts_export.xlsx');

      await file.writeAsBytes(bytes, flush: true);

      print('Excel saved: ${file.path}');
    } catch (e) {
      print('Export error: $e');
    }
  }

  @override
  void dispose() {
    database.close();
    super.dispose();
  }

  String? getCC(String number) {
    try {
      number = number.replaceAll(RegExp(r'[^0-9+]'), '');

      if (!number.startsWith('+')) {
        return null;
      }

      final parsed = PhoneNumber.parse(number);

      return parsed.countryCode;
    } catch (e) {
      return null;
    }
  }

  void getCountryCode() {
    for (final contact in contactsList) {
      final cc = getCC(contact.mobileNumber);

      try {
        print(
          '${contact.mobileNumber} -> $cc -> ${PhoneNumber.parse(contact.mobileNumber).nsn}',
        );
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DB Import",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),

      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateNewContact(),
                      ),
                    );

                    if (result == true) {
                      //   for (final c in contactsList) {
                      //     print("${c.id} ${c.name}");
                      //   }
                      await loadContacts();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("New"),
                ),

                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: isImporting ? null : importContacts,
                  icon: const Icon(Icons.download),
                  label: const Text("Import"),
                ),

                const SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Long press to delete all contacts"),
                      ),
                    );
                  },
                  onLongPress: deleteContacts,
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete All"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Text(
                  "Contacts in DB: ${contactsList.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await exportContactsToExcel();
                  },
                  icon: Icon(Icons.upload),
                  label: Text("Export"),
                ),
              ],
            ),

            // getting of country-code this  was just for testing
            ElevatedButton(
              onPressed: () {
                getCountryCode();
              },
              child: Text(
                "get "
                "country codes",
              ),
            ),
            TextField(
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                  loadContacts();
                });
              },
              decoration: InputDecoration(
                hintText: "Search contacts...",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),

            const SizedBox(height: 10),

            if (isImporting)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 8),
                    Text(
                      "${(progress * 100).toStringAsFixed(0)} %",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: contactsList.isEmpty
                  ? const Center(
                      child: Text(
                        "No contacts in database",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: contactsList.length,
                      // separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final contact = contactsList[index];

                        String contactname = contact.firstname;
                        String first = contactname
                            .toUpperCase()
                            .characters
                            .first;
                        final id = contact.id;
                        String number = "";

                        if (contact.mobileNumber.isNotEmpty)
                          number = contact.mobileNumber;
                        else if (contact.workNumber.isNotEmpty)
                          number = contact.workNumber;
                        else if (contact.phoneNumber.isNotEmpty)
                          number = contact.phoneNumber;
                        else
                          number = contact.mainNumber;

                        return Material(
                          color: Colors.black87,
                          child: ListTile(
                            onLongPress: () async {
                              final selected = await showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(100, 300, 0, 0),
                                items: [
                                  // PopupMenuItem(
                                  //   enabled: false,
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       Text(
                                  //         contactname,
                                  //         style: TextStyle(
                                  //           fontWeight: FontWeight.bold,
                                  //           fontSize: 16,
                                  //         ),
                                  //       ),
                                  //       SizedBox(height: 4),
                                  //       Text(
                                  //         contact.phone,
                                  //         style: TextStyle(
                                  //           color: Colors.grey,
                                  //           fontSize: 13,
                                  //         ),
                                  //       ),
                                  //       Divider(height: 20),
                                  //     ],
                                  //   ),
                                  // ),

                                  // PopupMenuItem(
                                  //   onTap: () {
                                  //     Clipboard.setData(
                                  //       ClipboardData(text: contact.phone),
                                  //     );
                                  //   },
                                  //   child: ListTile(
                                  //     leading: Icon(Icons.copy_outlined),
                                  //     title: Text("Copy Number"),
                                  //     dense: true,
                                  //     contentPadding: EdgeInsets.zero,
                                  //   ),
                                  // ),
                                  PopupMenuItem(
                                    onTap: () async {
                                      // Navigate to edit screen
                                      final edited = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Editscreen(
                                            id: id,
                                            firstname: contact.firstname,
                                            lastname: contact.lastname,
                                            address: contact.address,
                                            dob: contact.dob,
                                            mainNumber: contact.mainNumber,
                                            phoneNumber: contact.phoneNumber,
                                            workNumber: contact.workNumber,
                                            mobileNumber: contact.mobileNumber,
                                            email: contact.email,
                                          ),
                                        ),
                                      );

                                      if (edited == true) {
                                        await loadContacts();
                                      }
                                    },
                                    child: ListTile(
                                      leading: Icon(Icons.edit_outlined),
                                      title: Text("Edit Contact"),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),

                                  PopupMenuItem(
                                    onTap: () {
                                      Future.delayed(Duration.zero, () {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Row(
                                              children: [
                                                Icon(
                                                  Icons.warning_amber_rounded,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 10),
                                                Text("Delete Contact"),
                                              ],
                                            ),
                                            content: Text(
                                              "Are you sure you want to delete $contactname?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                },
                                                child: Text("Cancel"),
                                              ),
                                              ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  await database.deleteContact(
                                                    id,
                                                  );
                                                  Navigator.pop(dialogContext);
                                                  loadContacts();
                                                },
                                                icon: Icon(Icons.delete),
                                                label: Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      title: Text(
                                        "Delete Contact",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              );
                            },
                            onTap: () async {
                              final ischanged = Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ContactDetailsScreen(contact: contact),
                                ),
                              );

                              // if (ischanged == true || ischanged == false) {
                              await loadContacts();
                              // }
                            },
                            leading: CircleAvatar(child: Text("${first}")),
                            title: Text(
                              "${contact.firstname + " " + contact.lastname}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white70),
                            ),
                            subtitle: Text(
                              "${number}",
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: Icon(Icons.info),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
