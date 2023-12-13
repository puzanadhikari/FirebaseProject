class Employee {
  late final String id;
  late final String fullName;
  late final String address;
  late final String mail;
  final String contact;
  final String gender;
  final bool fingerPrint;
  // final String signature;

  Employee({
    required this.id,
    required this.fullName,
    required this.address,
    required this.mail,
    required this.contact,
    required this.gender,
    required this.fingerPrint,
    // required this.signature,
  });

  // Add a factory constructor to convert JSON to an Employee object
  factory Employee.fromJson(String id,Map<String, dynamic> json) {
    return Employee(
      id: id,
      fullName: json['FullName'],
      address: json['Address'],
      mail: json['Mail'],
      contact: json['Contact'],
      gender: json['Gender'],
      fingerPrint: json['FingerPrint'],
      // signature: json['Signature'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FullName': fullName,
      'Address': address,
      'Mail': mail,
      'Contact': contact,
      'Gender': gender,
      'FingerPrint': fingerPrint,
    };
  }
}
