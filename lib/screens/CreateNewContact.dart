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
    await database.insertToDb(
      firstnameController.text.trim(),
      lastnameController.text.trim(),
      emailController.text.trim(),
      mobileController.text.trim(),
      workController.text.trim(),
      phoneController.text.trim(),
      mainController.text.trim(),
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
                  "Phone Numbers",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              buildField(
                mobileController,
                "Mobile Number (+91xxxxxxxxxx)",
                Icons.smartphone,
              ),

              buildField(workController, "Work Number", Icons.work),

              buildField(phoneController, "Home Number", Icons.phone),

              buildField(mainController, "Main Number", Icons.call),

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
