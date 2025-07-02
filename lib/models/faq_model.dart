class FaqModel {
  final String id;
  final String question;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['_id'],
      question: json['question'],
      answer: json['answer'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
      'answer': answer,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
