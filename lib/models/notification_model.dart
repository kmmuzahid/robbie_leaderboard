class NotificationModel {
  final String id;
  final String title;
  final String text;
  final String type;
  final DateTime createdAt;
  final int v;

  NotificationModel({
    required this.id,
    required this.title,
    required this.text,
    required this.type,
    required this.createdAt,
    required this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      type: json['type'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now()),
      v: json['__v'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'text': text,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      '__v': v,
    };
  }
}
