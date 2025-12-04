enum AppointmentStatus { pending, confirmed, completed, cancelled }

class Appointment {
  final String id;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String doctorId;
  final String doctorName;
  final String specialtyName;
  final DateTime date;
  final String timeSlot;
  final AppointmentStatus status;
  final String? notes;
  final String? cancellationReason;
  final int? rating;
  final String? review;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.doctorId,
    required this.doctorName,
    required this.specialtyName,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.notes,
    this.cancellationReason,
    this.rating,
    this.review,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientId': clientId,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'doctorId': doctorId,
    'doctorName': doctorName,
    'specialtyName': specialtyName,
    'date': date.toIso8601String(),
    'timeSlot': timeSlot,
    'status': status.name,
    'notes': notes,
    'cancellationReason': cancellationReason,
    'rating': rating,
    'review': review,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'],
    clientId: json['clientId'],
    clientName: json['clientName'],
    clientPhone: json['clientPhone'],
    doctorId: json['doctorId'],
    doctorName: json['doctorName'],
    specialtyName: json['specialtyName'],
    date: DateTime.parse(json['date']),
    timeSlot: json['timeSlot'],
    status: AppointmentStatus.values.firstWhere((e) => e.name == json['status']),
    notes: json['notes'],
    cancellationReason: json['cancellationReason'],
    rating: json['rating'],
    review: json['review'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Appointment copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? clientPhone,
    String? doctorId,
    String? doctorName,
    String? specialtyName,
    DateTime? date,
    String? timeSlot,
    AppointmentStatus? status,
    String? notes,
    String? cancellationReason,
    int? rating,
    String? review,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Appointment(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    clientName: clientName ?? this.clientName,
    clientPhone: clientPhone ?? this.clientPhone,
    doctorId: doctorId ?? this.doctorId,
    doctorName: doctorName ?? this.doctorName,
    specialtyName: specialtyName ?? this.specialtyName,
    date: date ?? this.date,
    timeSlot: timeSlot ?? this.timeSlot,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    cancellationReason: cancellationReason ?? this.cancellationReason,
    rating: rating ?? this.rating,
    review: review ?? this.review,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  bool get isPast => date.isBefore(DateTime.now());
  bool get isFuture => date.isAfter(DateTime.now());
  bool get canCancel =>
      isFuture &&
          status != AppointmentStatus.cancelled &&
          date.difference(DateTime.now()).inHours >= 24;
}
