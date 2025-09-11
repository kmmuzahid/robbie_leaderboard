class HallOfFameSinglePaymentModel {
  final String id;
  final String name;
  final String country;
  final String gender;
  final int views;
  final num totalInvested;
  final String profileImg;

  HallOfFameSinglePaymentModel({
    required this.id,
    required this.name,
    required this.country,
    required this.gender,
    required this.views,
    required this.totalInvested,
    required this.profileImg,
  });

  factory HallOfFameSinglePaymentModel.fromJson(Map<String, dynamic> json) {
    return HallOfFameSinglePaymentModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      gender: json['gender'] ?? '',
      views: json['views'] ?? 0,
      totalInvested:  json['totalInvested'] ?? 0.0,
      profileImg: json['profileImg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'country': country,
      'gender': gender,
      'views': views,
      'totalInvested': totalInvested,
    };
  }
}
