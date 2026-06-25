// class LocalContact {
//   final String firstname;
//   final String lastname;
//   final String email;
//
//   final String mobileNumber;
//   final String workNumber;
//   final String phoneNumber;
//   final String mainNumber;
//
//   final DateTime dob;
//   final String address;
//
//   LocalContact({
//     required this.firstname,
//     required this.lastname,
//     required this.email,
//     required this.mobileNumber,
//     required this.workNumber,
//     required this.phoneNumber,
//     required this.mainNumber,
//     required this.dob,
//     required this.address,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'firstname': firstname,
//       'lastname': lastname,
//       'email': email,
//       'mobileNumber': mobileNumber,
//       'workNumber': workNumber,
//       'phoneNumber': phoneNumber,
//       'mainNumber': mainNumber,
//       'dob': dob.toIso8601String(),
//       'address': address,
//     };
//   }
//
//   factory LocalContact.fromMap(Map<dynamic, dynamic> map) {
//     return LocalContact(
//       firstname: map['firstname'] ?? '',
//       lastname: map['lastname'] ?? '',
//       email: map['email'] ?? '',
//       mobileNumber: map['mobileNumber'] ?? '',
//       workNumber: map['workNumber'] ?? '',
//       phoneNumber: map['phoneNumber'] ?? '',
//       mainNumber: map['mainNumber'] ?? '',
//       dob: map['dob'] != null ? DateTime.parse(map['dob']) : DateTime.now(),
//       address: map['address'] ?? '',
//     );
//   }
// }
