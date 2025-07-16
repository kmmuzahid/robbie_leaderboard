class RecentActivityReceiveModel {
  final String title;
  final String subTitle;
  final String type;
  final String createdAt;

  RecentActivityReceiveModel({
    required this.title,
    required this.subTitle,
    required this.type,
    required this.createdAt
  });

  factory RecentActivityReceiveModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityReceiveModel(
      title: json['title'] ?? '',
      subTitle: json['subTitle'] ?? '',
      type: json['type'] ?? '',
      createdAt: json['createdAt']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subTitle': subTitle,
      'type': type,
      'createdAt': createdAt
    };
  }
}
