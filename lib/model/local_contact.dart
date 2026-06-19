class LocalContact {
  final String name;
  final String phone;

  LocalContact({required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {'name': name, 'phone': phone};
  }

  factory LocalContact.fromMap(Map<dynamic, dynamic> map) {
    return LocalContact(name: map['name'] ?? '', phone: map['phone'] ?? '');
  }
}
