class CountryLeaderboardModel {
  final double totalInvest;
  final String country;
  final int totalUsers;

  CountryLeaderboardModel({
    required this.totalInvest,
    required this.country,
    required this.totalUsers,
  });

  // Create an instance from JSON
  factory CountryLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return CountryLeaderboardModel(
      totalInvest: json['totalInvest'] ?? 0.0,
      country: json['country'] ?? '',
      totalUsers: json['totalUsers'] ?? 0,
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalInvest': totalInvest,
      'country': country,
      'totalUsers': totalUsers,
    };
  }

  @override
  String toString() {
    return 'CountryLeaderboardModel(totalInvest: $totalInvest, country: $country, totalUsers: $totalUsers)';
  }
}
