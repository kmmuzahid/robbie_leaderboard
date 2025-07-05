class CurrentRuffleModel {
  final String id;
  final DateTime deadline;
  final int prizeMoney;
  final List<int> ticketButtons;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CurrentRuffleModel({
    required this.id,
    required this.deadline,
    required this.prizeMoney,
    required this.ticketButtons,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CurrentRuffleModel.fromJson(Map<String, dynamic> json) {
    return CurrentRuffleModel(
      id: json['_id'] ?? '',
      deadline: DateTime.parse(json['deadline']),
      prizeMoney: json['prizeMoney'] ?? 0,
      ticketButtons: List<int>.from(json['ticketButtons'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'deadline': deadline.toIso8601String(),
      'prizeMoney': prizeMoney,
      'ticketButtons': ticketButtons,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
