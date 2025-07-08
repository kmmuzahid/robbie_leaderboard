class RecentActivityModel {
  final String name;
  final String activity;
  // final String time;

  RecentActivityModel({
    required this.name,
    required this.activity,
    // required this.time,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      name: json['userName'] ?? '',
      activity: json['amount'] ?? '', //qty -ticket , amount, userName
      // time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'activity': activity,
      // 'time': time,
    };
  }
}
