import 'package:flutter/material.dart';
import 'package:my_contact_list/db/app_database.dart' as db;
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CreateNewContact extends StatefulWidget {
  const CreateNewContact({super.key});

  @override
  State<CreateNewContact> createState() => _CreateNewContactState();
}

class _CreateNewContactState extends State<CreateNewContact> {
  final database = db.AppDatabase();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController workController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mainController = TextEditingController();

  final TextEditingController mobileccController = TextEditingController();
  final TextEditingController workccController = TextEditingController();
  final TextEditingController phoneccController = TextEditingController();
  final TextEditingController mainccController = TextEditingController();

  final TextEditingController dobcontroller = TextEditingController();

  DateTime? selectedDob;

  Widget buildField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: hint.contains("Number")
            ? TextInputType.phone
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: dobcontroller,
        readOnly: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Birth Date",
          labelStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.cake),
          suffixIcon: const Icon(Icons.calendar_month),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDob ?? DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              selectedDob = pickedDate;

              dobcontroller.text =
                  "${pickedDate.day.toString().padLeft(2, '0')}/"
                  "${pickedDate.month.toString().padLeft(2, '0')}/"
                  "${pickedDate.year}";
            });
          }
        },
      ),
    );
  }

  final TextEditingController addressController = TextEditingController();
  bool isValidPhone(String phone) {
    try {
      return PhoneNumber.parse(phone).isValid();
    } catch (_) {
      return false;
    }
  }

  Future<void> addContact() async {
    if (firstnameController.text.trim().isEmpty &&
        lastnameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Name field is missing")));
      return;
    }

    if (mobileController.text.trim().isEmpty &&
        workController.text.trim().isEmpty &&
        phoneController.text.trim().isEmpty &&
        mainController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Number field is missing")));
      return;
    }

    // Mobile
    if (mobileController.text.trim().isNotEmpty) {
      if (mobileccController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fill CC for Mobile Number")),
        );
        return;
      }

      try {
        PhoneNumber.parse("${mobileccController.text.trim()}");
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Country Code for Mobile Number"),
          ),
        );
        return;
      }
    }

    // Work
    if (workController.text.trim().isNotEmpty) {
      if (workccController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fill CC for Work Number")),
        );
        return;
      }

      try {
        PhoneNumber.parse("${workccController.text.trim()}");
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Country Code for Work Number")),
        );
        return;
      }
    }

    // Phone
    if (phoneController.text.trim().isNotEmpty) {
      if (phoneccController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fill CC for Phone Number")),
        );
        return;
      }

      try {
        PhoneNumber.parse("${phoneccController.text.trim()}");
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Country Code for Phone Number"),
          ),
        );
        return;
      }
    }

    // Main
    if (mainController.text.trim().isNotEmpty) {
      if (mainccController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fill CC for Main Number")),
        );
        return;
      }

      try {
        PhoneNumber.parse("${mainccController.text.trim()}");
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Country Code for Main Number")),
        );
        return;
      }
    }

    final mobileNumber =
        mobileccController.text.trim() + mobileccController.text.trim();

    final workNumber =
        workccController.text.trim() + workController.text.trim();
    final phoneNumber =
        phoneccController.text.trim() + phoneController.text.trim();
    final mainNumber =
        mainccController.text.trim() + mainController.text.trim();

    await database.insertToDb(
      firstnameController.text.trim(),
      lastnameController.text.trim(),
      emailController.text.trim(),
      mobileNumber,
      workNumber,
      phoneNumber,
      mainNumber,
      selectedDob ?? DateTime.now(),
      addressController.text.trim(),
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    workController.dispose();
    phoneController.dispose();
    mainController.dispose();
    dobcontroller.dispose();
    addressController.dispose();

    database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "Create New Contact",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                child: Icon(Icons.person, size: 45),
              ),

              const SizedBox(height: 20),

              buildField(firstnameController, "First Name", Icons.person),

              buildField(lastnameController, "Last Name", Icons.person_outline),

              buildField(emailController, "Email", Icons.email),

              const SizedBox(height: 15),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Phone Numbers ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Atleast 1 is needed",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "CC -> Country Code",
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextField(
                        controller: mobileccController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "CC",
                          labelStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          labelStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.smartphone),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextField(
                        controller: workccController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "CC",
                          labelStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: workController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Work Number",
                          labelStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.work),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextField(
                        controller: phoneccController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "CC",
                          labelStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.phone),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextField(
                        controller: mainccController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "CC",
                          labelStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: mainController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Main Number",
                          labelStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(Icons.call),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              buildDateField(),
              buildField(addressController, "Address", Icons.home),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: addContact,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Save Contact",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
