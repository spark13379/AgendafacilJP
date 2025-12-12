import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agendafaciljp/models/user.dart';

class TimeSlot {
  final String start;
  final String end;

  TimeSlot({required this.start, required this.end});

  Map<String, dynamic> toJson() => {'start': start, 'end': end};

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      TimeSlot(start: json['start'], end: json['end']);
}

class Doctor extends User {
  final String crm;
  final String specialtyId;
  final String specialtyName;
  final String bio;
  final double rating;
  final int ratingCount;
  final bool isActive;
  final Map<String, List<TimeSlot>> availableSchedule;
  final List<DateTime> blockedDates;

  Doctor({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.photoUrl,
    required super.createdAt,
    required super.updatedAt,
    required this.crm,
    required this.specialtyId,
    required this.specialtyName,
    required this.bio,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.isActive = true, // Padrão é ativo
    Map<String, List<TimeSlot>>? availableSchedule,
    List<DateTime>? blockedDates,
  }) : availableSchedule = availableSchedule ?? {},
        blockedDates = blockedDates ?? [],
        super(role: UserRole.doctor);

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'crm': crm,
    'specialtyId': specialtyId,
    'specialtyName': specialtyName,
    'bio': bio,
    'rating': rating,
    'ratingCount': ratingCount,
    'isActive': isActive,
    'availableSchedule': availableSchedule.map(
          (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
    ),
    'blockedDates': blockedDates.map((e) => e.toIso8601String()).toList(),
  };

  factory Doctor.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) {
        return date.toDate();
      }
      if (date is String) {
        return DateTime.parse(date);
      }
      return DateTime.now(); // Fallback
    }

    return Doctor(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      crm: json['crm'],
      specialtyId: json['specialtyId'],
      specialtyName: json['specialtyName'],
      bio: json['bio'],
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['ratingCount'],
      isActive: json['isActive'] ?? true, 
      availableSchedule: (json['availableSchedule'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(
          key,
          (value as List)
              .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      blockedDates: (json['blockedDates'] as List? ?? [])
          .map((e) => parseDate(e))
          .toList(),
    );
  }

 Doctor copyWithDoctor({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? crm,
    String? specialtyId,
    String? specialtyName,
    String? bio,
    double? rating,
    int? ratingCount,
    bool? isActive,
    Map<String, List<TimeSlot>>? availableSchedule,
    List<DateTime>? blockedDates,
  }) => Doctor(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    photoUrl: photoUrl ?? this.photoUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    crm: crm ?? this.crm,
    specialtyId: specialtyId ?? this.specialtyId,
    specialtyName: specialtyName ?? this.specialtyName,
    bio: bio ?? this.bio,
    rating: rating ?? this.rating,
    ratingCount: ratingCount ?? this.ratingCount,
    isActive: isActive ?? this.isActive,
    availableSchedule: availableSchedule ?? this.availableSchedule,
    blockedDates: blockedDates ?? this.blockedDates,
  );
}