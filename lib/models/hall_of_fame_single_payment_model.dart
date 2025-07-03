class HallOfFameSinglePaymentModel {
  final String? id;
  final String? name;
  final String? country;
  final String? gender;
  final String? profileImg;
  final int? views;
  final String? totalInvested;

  HallOfFameSinglePaymentModel(
      {this.id,
      this.name,
      this.country,
      this.gender,
      this.profileImg,
      this.views,
      this.totalInvested});

  factory HallOfFameSinglePaymentModel.fromJson(Map<String, dynamic> json) {
    return HallOfFameSinglePaymentModel(
        id: json['_id'],
        name: json['name'],
        country: json['country'],
        gender: json['gender'],
        profileImg: json['profileImg'],
        views: json['views'],
        totalInvested: json['totalInvested']);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'country': country,
      'gender': gender,
      'profileImg': profileImg,
      'views': views,
      'totalInvested': totalInvested
    };
  }
}
