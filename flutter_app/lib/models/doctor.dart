class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String hospital;
  final String? profileImage;
  final double rating;
  final int reviewCount;
  final int yearsExperience;
  final int patientCount;
  final String? about;
  final String? workingHours;
  final String? category;
  final double? consultationFee;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.hospital,
    this.profileImage,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.yearsExperience = 0,
    this.patientCount = 0,
    this.about,
    this.workingHours,
    this.category,
    this.consultationFee,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      hospital: json['hospital'] ?? '',
      profileImage: json['profileImage'],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      yearsExperience: json['yearsExperience'] ?? 0,
      patientCount: json['patientCount'] ?? 0,
      about: json['about'],
      workingHours: json['workingHours'],
      category: json['category'],
      consultationFee: json['consultationFee']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'hospital': hospital,
      'profileImage': profileImage,
      'rating': rating,
      'reviewCount': reviewCount,
      'yearsExperience': yearsExperience,
      'patientCount': patientCount,
      'about': about,
      'workingHours': workingHours,
      'category': category,
      'consultationFee': consultationFee,
    };
  }
}
