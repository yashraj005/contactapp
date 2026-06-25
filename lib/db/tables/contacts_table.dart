import 'package:drift/drift.dart';

class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get firstname => text()();

  TextColumn get lastname => text()();
  TextColumn get email => text()();

  TextColumn get mobileNumber => text()();
  TextColumn get workNumber => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get mainNumber => text()();

  DateTimeColumn get dob => dateTime()();

  TextColumn get address => text()();
}
