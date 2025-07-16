class TicketWonSocketModel {
  final String title;
  final String text;
  final String type;
  final String createdAt;

  TicketWonSocketModel({
    required this.title,
    required this.text,
    required this.type,
    required this.createdAt
  });

  factory TicketWonSocketModel.fromJson(Map<String, dynamic> json) =>
      TicketWonSocketModel(
        title: json['title'] as String? ?? '',
        text: json['text'] as String? ?? '',
        type: json['type'] as String? ?? '',
        createdAt: json['createdAt'] as String? ?? ''
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'text': text,
        'type': type,
        'createdAt': createdAt
      };
}
