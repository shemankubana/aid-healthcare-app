class Appointment {
  final String? id;
  final String doctorId;
  final String userId;
  final DateTime date;
  final String time;
  final String timeSlot;
  final String symptoms;
  final double amount;
  final String? status;
  final DateTime? createdAt;

  Appointment({
    this.id,
    required this.doctorId,
    required this.userId,
    required this.date,
    required this.time,
    required this.timeSlot,
    required this.symptoms,
    required this.amount,
    this.status,
    this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString(),
      doctorId: json['doctorId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      time: json['time'] ?? '',
      timeSlot: json['timeSlot'] ?? '',
      symptoms: json['symptoms'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'userId': userId,
      'date': date.toIso8601String(),
      'time': time,
      'timeSlot': timeSlot,
      'symptoms': symptoms,
      'amount': amount,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
