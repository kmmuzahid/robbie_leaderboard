class RecentActivityModel {
  final String id;
  final String title;
  final String text;
  final String type;
  final DateTime createdAt;

  RecentActivityModel({
    required this.id,
    required this.title,
    required this.text,
    required this.type,
    required this.createdAt,
  });

  // From JSON
  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'text': text,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Optional: CopyWith method for immutability
  RecentActivityModel copyWith({
    String? id,
    String? title,
    String? text,
    String? type,
    DateTime? createdAt,
  }) {
    return RecentActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'RecentActivity(id: $id, title: $title, text: $text, type: $type, createdAt: $createdAt)';
  }
}
