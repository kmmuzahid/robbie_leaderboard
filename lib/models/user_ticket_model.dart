class UserTicketsModel {
  final int totalTickets;
  final String userId;
  final String name;
  final List<Ticket> tickets;
  final int spinCount;

  UserTicketsModel({
    required this.totalTickets,
    required this.userId,
    required this.name,
    required this.tickets,
    required this.spinCount,
  });

  factory UserTicketsModel.fromJson(Map<String, dynamic> json) {
    return UserTicketsModel(
      totalTickets: json['totalTickets'] ?? 0,
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      spinCount: json['spinCount'] ?? 0,
      tickets: (json['tickets'] as List<dynamic>).map((e) => Ticket.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTickets': totalTickets,
      'spinCount': spinCount,
      'userId': userId,
      'name': name,
      'tickets': tickets.map((e) => e.toJson()).toList(),
    };
  }
}

class Ticket {
  final String id;
  final int qty;
  final DateTime createdAt;

  Ticket({
    required this.id,
    required this.qty,
    required this.createdAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'] ?? '',
      qty: json['qty'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'qty': qty,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
