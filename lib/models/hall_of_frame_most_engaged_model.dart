class HallOfFrameMostEngagedModel {
  final String id;
  final String name;
  final String country;
  final String gender;
  final String profileImg;
  final int views;

  HallOfFrameMostEngagedModel({
    required this.id,
    required this.name,
    required this.country,
    required this.gender,
    required this.profileImg,
    required this.views,
  });

  factory HallOfFrameMostEngagedModel.fromJson(Map<String, dynamic> json) {
    return HallOfFrameMostEngagedModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      gender: json['gender'] ?? '',
      profileImg: json['profileImg'] ?? '',
      views: json['views'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'country': country,
      'gender': gender,
      'profileImg': profileImg,
      'views': views,
    };
  }
}
