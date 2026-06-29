import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_contact_list/phpdb/Contact.dart';

class Apiservice {
  static const String baseurl = "http://10.82.90.96/contactapp_api";
  Future<List<Contact>> getContacts() async {
    final response = await http.get(Uri.parse("$baseurl/fetch.php"));
    if (response.statusCode == 200) {
      List jsondata = jsonDecode(response.body);
      return jsondata.map((e) => Contact.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> addContacts(
    String firstname,
    String lastname,
    String email,
    String mobileNumber,
    String phoneNumber,
    String workNumber,
    String mainNumber,
    DateTime dob,
    String address,
  ) async {
    final response = await http.post(
      Uri.parse("$baseurl/insert.php"),
      body: {
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'mobileNumber': mobileNumber,
        'phoneNumber': phoneNumber,
        'workNumber': workNumber,
        'mainNumber': mainNumber,
        'dob': dob.toIso8601String().split('T')[0],
        'address': address,
      },
    );
    return response.body.trim() == "success";
  }

  Future<bool> updateContacts(
    String id,
    String firstname,
    String lastname,
    String email,
    String mobileNumber,
    String phoneNumber,
    String workNumber,
    String mainNumber,
    DateTime dob,
    String address,
  ) async {
    final response = await http.post(
      Uri.parse("$baseurl/update.php"),
      body: {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'mobileNumber': mobileNumber,
        'phoneNumber': phoneNumber,
        'workNumber': workNumber,
        'mainNumber': mainNumber,
        'dob': dob.toIso8601String().split('T')[0],
        'address': address,
      },
    );
    return response.body.trim() == "success";
  }

  Future<bool> deleteContact(String id) async {
    final response = await http.post(
      Uri.parse("$baseurl/delete.php"),
      body: {'id': id},
    );
    return response.body.trim() == "success";
  }

  Future<bool> deleteAll() async {
    final response = await http.get(Uri.parse("$baseurl/deleteAll.php"));
    return response.body.trim() == "success";
  }
}
