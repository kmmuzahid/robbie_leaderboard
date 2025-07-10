class RecentActivityReceiveModel {
  final String title;
  final String subTitle;
  final String type;

  RecentActivityReceiveModel({
    required this.title,
    required this.subTitle,
    required this.type,
  });

  factory RecentActivityReceiveModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityReceiveModel(
      title: json['title'] ?? '',
      subTitle: json['subTitle'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subTitle': subTitle,
      'type': type,
    };
  }
}
