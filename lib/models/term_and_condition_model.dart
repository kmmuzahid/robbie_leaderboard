class TermAndConditionModel {
  final String id;
  final int v;
  final DateTime createdAt;
  final String text;
  final DateTime updatedAt;

  TermAndConditionModel({
    required this.id,
    required this.v,
    required this.createdAt,
    required this.text,
    required this.updatedAt,
  });

  factory TermAndConditionModel.fromJson(Map<String, dynamic> json) {
    return TermAndConditionModel(
      id: json['_id'],
      v: json['__v'],
      createdAt: DateTime.parse(json['createdAt']),
      text: json['text'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      '__v': v,
      'createdAt': createdAt.toIso8601String(),
      'text': text,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
