class Contact {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String mobileNumber;
  final String phoneNumber;
  final String workNumber;
  final String mainNumber;
  final DateTime dob;
  final String address;
  Contact({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.mobileNumber,
    required this.phoneNumber,
    required this.workNumber,
    required this.mainNumber,
    required this.dob,
    required this.address,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: int.parse(json['id'].toString()),
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      phoneNumber: json['phoneNumber'],
      workNumber: json['workNumber'],
      mainNumber: json['mainNumber'],
      dob: DateTime.parse(json['dob']),
      address: json['address'],
    );
  }
}
