import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:my_contact_list/screens/LoadingScreen.dart';
import 'package:my_contact_list/screens/contacts_screen.dart';
import 'package:my_contact_list/screens/dialpad_screen.dart';
import 'package:my_contact_list/screens/favorites_screen.dart';
import 'package:my_contact_list/screens/recents_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const LoadingScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;

  final pages = const [DialPadScreen(), RecentsScreen(), ContactsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dialpad), label: 'Dial'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Recents'),
          NavigationDestination(icon: Icon(Icons.contacts), label: 'Contacts'),
        ],
      ),
    );
  }
}
