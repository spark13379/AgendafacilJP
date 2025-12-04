class Specialty {
  final String id;
  final String name;
  final String iconName;
  final String description;
  final DateTime createdAt;

  Specialty({
    required this.id,
    required this.name,
    required this.iconName,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'iconName': iconName,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Specialty.fromJson(Map<String, dynamic> json) => Specialty(
    id: json['id'],
    name: json['name'],
    iconName: json['iconName'],
    description: json['description'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Specialty copyWith({
    String? id,
    String? name,
    String? iconName,
    String? description,
    DateTime? createdAt,
  }) => Specialty(
    id: id ?? this.id,
    name: name ?? this.name,
    iconName: iconName ?? this.iconName,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
  );
}
