import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_contact_list/screens/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('contactsBox');

  runApp(const MyApp());
}
