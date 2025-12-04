enum NotificationType { confirmation, reminder, reschedule, cancellation }

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final String? relatedAppointmentId;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    this.relatedAppointmentId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'message': message,
    'type': type.name,
    'isRead': isRead,
    'relatedAppointmentId': relatedAppointmentId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'],
    userId: json['userId'],
    title: json['title'],
    message: json['message'],
    type: NotificationType.values.firstWhere((e) => e.name == json['type']),
    isRead: json['isRead'],
    relatedAppointmentId: json['relatedAppointmentId'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  AppNotification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    String? relatedAppointmentId,
    DateTime? createdAt,
  }) => AppNotification(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    message: message ?? this.message,
    type: type ?? this.type,
    isRead: isRead ?? this.isRead,
    relatedAppointmentId: relatedAppointmentId ?? this.relatedAppointmentId,
    createdAt: createdAt ?? this.createdAt,
  );
}
