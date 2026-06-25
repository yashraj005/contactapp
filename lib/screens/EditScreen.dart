import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import '../db/app_database.dart' as db;

class Editscreen extends StatefulWidget {
  final int id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? mobileNumber;
  final String? workNumber;
  final String? phoneNumber;
  final String? mainNumber;
  final DateTime? dob;
  final String? address;

  Editscreen({
    super.key,
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.address,
    required this.dob,
    required this.mainNumber,
    required this.phoneNumber,
    required this.workNumber,
    required this.mobileNumber,
    required this.email,
  });

  @override
  State<Editscreen> createState() => _EditscreenState();
}

class _EditscreenState extends State<Editscreen> {
  final database = db.AppDatabase();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController mobileNumberController;
  late TextEditingController workNumberController;
  late TextEditingController phoneNumberController;
  late TextEditingController mainNumberController;
  late TextEditingController mobileNumberccController;
  late TextEditingController workNumberccController;
  late TextEditingController phoneNumberccController;
  late TextEditingController mainNumberccController;
  late TextEditingController dobController;
  late TextEditingController addressController;
  void _splitNumber(
    String? number,
    TextEditingController ccController,
    TextEditingController numberController,
  ) {
    if (number == null || number.trim().isEmpty) return;

    try {
      final parsed = PhoneNumber.parse(number);

      ccController.text = "+${parsed.countryCode}";
      numberController.text = parsed.nsn;
    } catch (_) {
      // Couldn't parse, keep original number
      numberController.text = number;
    }
  }

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(text: widget.firstname ?? "");
    lastNameController = TextEditingController(text: widget.lastname ?? "");
    emailController = TextEditingController(text: widget.email ?? "");

    mobileNumberController = TextEditingController(
      text: widget.mobileNumber ?? "",
    );
    workNumberController = TextEditingController(text: widget.workNumber ?? "");
    phoneNumberController = TextEditingController(
      text: widget.phoneNumber ?? "",
    );
    mainNumberController = TextEditingController(text: widget.mainNumber ?? "");

    mobileNumberccController = TextEditingController();
    workNumberccController = TextEditingController();
    phoneNumberccController = TextEditingController();
    mainNumberccController = TextEditingController();

    _splitNumber(
      widget.mobileNumber,
      mobileNumberccController,
      mobileNumberController,
    );
    _splitNumber(
      widget.workNumber,
      workNumberccController,
      workNumberController,
    );
    _splitNumber(
      widget.phoneNumber,
      phoneNumberccController,
      phoneNumberController,
    );
    _splitNumber(
      widget.mainNumber,
      mainNumberccController,
      mainNumberController,
    );

    dobController = TextEditingController(
      text: widget.dob?.toString().split(' ')[0] ?? '',
    );

    addressController = TextEditingController(text: widget.address ?? "");
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    workNumberController.dispose();
    phoneNumberController.dispose();
    mainNumberController.dispose();
    dobController.dispose();
    addressController.dispose();

    database.close();
    super.dispose();
  }

  Widget buildPhoneField({
    required TextEditingController ccController,
    required TextEditingController numberController,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: TextField(
              controller: ccController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "CC",
                labelStyle: const TextStyle(color: Colors.purpleAccent),
                prefixIcon: const Icon(Icons.flag, color: Colors.purpleAccent),
                filled: true,
                fillColor: const Color(0xFF2A1B3D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.purpleAccent,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Colors.purpleAccent),
                prefixIcon: Icon(icon, color: Colors.purpleAccent),
                filled: true,
                fillColor: const Color(0xFF2A1B3D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.purpleAccent,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.purpleAccent),
          prefixIcon: Icon(icon, color: Colors.purpleAccent),
          filled: true,
          fillColor: const Color(0xFF2A1B3D),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Edit Contact",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color(0xFF121212),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.purple,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "${firstNameController.text} ${lastNameController.text}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // PERSONAL INFO
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Personal Information",
                          style: TextStyle(
                            color: Colors.purple.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            buildField(
                              controller: firstNameController,
                              label: "First Name",
                              icon: Icons.person,
                            ),
                            buildField(
                              controller: lastNameController,
                              label: "Last Name",
                              icon: Icons.person_outline,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // PHONE NUMBERS
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Phone Numbers",
                          style: TextStyle(
                            color: Colors.purple.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            buildPhoneField(
                              ccController: mobileNumberccController,
                              numberController: mobileNumberController,
                              label: "Mobile Number",
                              icon: Icons.phone_android,
                            ),
                            if (workNumberController.text.trim().isNotEmpty)
                              buildPhoneField(
                                ccController: workNumberccController,
                                numberController: workNumberController,
                                label: "Work Number",
                                icon: Icons.work,
                              ),
                            if (phoneNumberController.text.trim().isNotEmpty)
                              buildPhoneField(
                                ccController: phoneNumberccController,
                                numberController: phoneNumberController,
                                label: "Home Number",
                                icon: Icons.home,
                              ),
                            if (mainNumberController.text.trim().isNotEmpty)
                              buildPhoneField(
                                ccController: mainNumberccController,
                                numberController: mainNumberController,
                                label: "Main Number",
                                icon: Icons.call,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // CONTACT INFO
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Contact Information",
                          style: TextStyle(
                            color: Colors.purple.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            buildField(
                              controller: emailController,
                              label: "Email",
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            TextField(
                              controller: dobController,
                              readOnly: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Date of Birth",
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                prefixIcon: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: widget.dob ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );

                                if (picked != null) {
                                  dobController.text = picked.toString().split(
                                    ' ',
                                  )[0];
                                }
                              },
                            ),

                            const SizedBox(height: 15),

                            buildField(
                              controller: addressController,
                              label: "Address",
                              icon: Icons.location_on,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Update Contact",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () async {
                    DateTime dob =
                        DateTime.tryParse(dobController.text.trim()) ??
                        DateTime.now();

                    await database.updateContact(
                      widget.id,
                      firstNameController.text.trim(),
                      lastNameController.text.trim(),
                      emailController.text.trim(),
                      mobileNumberController.text.trim(),
                      workNumberController.text.trim(),
                      phoneNumberController.text.trim(),
                      mainNumberController.text.trim(),
                      dob,
                      addressController.text.trim(),
                    );

                    if (mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
