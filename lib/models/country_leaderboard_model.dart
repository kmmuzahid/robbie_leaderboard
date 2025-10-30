

class CountryLeaderboardModel {
  final num totalInvest;
  final String country;
  final int totalUsers;
  String? isoCode;

  CountryLeaderboardModel(this.totalInvest, this.country, this.totalUsers);

  factory CountryLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return CountryLeaderboardModel(json["totalInvest"] as num,
        json["country"] ?? "", json["totalUsers"] as int);
  }

  // void fetchFlag() async {
  //   final countryList = await getAllCountries();
  //   final countryName = countryList.firstWhere(
  //     (c) => c.name == country,
  //   );
  //   isoCode  =
  // }
}
