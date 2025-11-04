class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? insuranceProvider;
  final String? insuranceNumber;
  final String? address;
  final DateTime? dateOfBirth;
  final String? gender;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.insuranceProvider,
    this.insuranceNumber,
    this.address,
    this.dateOfBirth,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profileImage: json['profileImage'],
      insuranceProvider: json['insuranceProvider'],
      insuranceNumber: json['insuranceNumber'],
      address: json['address'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'insuranceProvider': insuranceProvider,
      'insuranceNumber': insuranceNumber,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
    };
  }
}
