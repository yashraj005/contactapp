import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/contacts_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Contacts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Insert Contact
  Future<void> insertToDb(
    String? firstname,
    String? lastname,
    String? email,
    String? mobileNumber,
    String? workNumber,
    String? phoneNumber,
    String? mainNumber,
    DateTime dob,
    String? address,
  ) async {
    await into(contacts).insert(
      ContactsCompanion.insert(
        firstname: firstname!,
        lastname: lastname!,
        email: email!,
        mobileNumber: mobileNumber!,
        workNumber: workNumber!,
        phoneNumber: phoneNumber!,
        mainNumber: mainNumber!,
        dob: dob,
        address: address!,
      ),
    );
  }

  // Get All Contacts (Alphabetical Order)
  Future<List<Contact>> getAllContacts() {
    return select(contacts).get();
  }

  // Get Single Contact
  Future<Contact?> getContact(int id) {
    return (select(contacts)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Update Contact
  Future<void> updateContact(
    int id,
    String? firstname,
    String? lastname,
    String? email,
    String? mobileNumber,
    String? workNumber,
    String? phoneNumber,
    String? mainNumber,
    DateTime? dob,
    String? address,
  ) async {
    await (update(contacts)..where((ppl) => ppl.id.equals(id))).write(
      ContactsCompanion(
        id: Value(id!),
        firstname: Value(firstname!),
        lastname: Value(lastname!),
        email: Value(email!),
        mobileNumber: Value(mobileNumber!),
        workNumber: Value(workNumber!),
        phoneNumber: Value(phoneNumber!),
        mainNumber: Value(mainNumber!),
        dob: Value(dob!),
        address: Value(address!),
      ),
    );
  }

  // Delete One Contact
  Future<void> deleteContact(int id) async {
    await (delete(contacts)..where((t) => t.id.equals(id))).go();
  }

  // Delete All Contacts
  Future<void> deleteAllContacts() async {
    await delete(contacts).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(p.join(dir.path, 'contacts.db'));

    return NativeDatabase(file);
  });
}
