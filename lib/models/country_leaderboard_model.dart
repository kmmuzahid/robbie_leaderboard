class CountryLeaderboardModel {
  final num totalInvest;
  final String country;
  final int totalUsers;
  CountryLeaderboardModel(this.totalInvest, this.country, this.totalUsers);

  factory CountryLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return CountryLeaderboardModel(json["totalInvest"] as num,
        json["country"] as String, json["totalUsers"] as int);
  }
}
