import 'dart:convert';

class CountryLeaderboardModel {
  final double totalInvest;
  final String country;
  final int totalUsers;
  final int currentRank;

  CountryLeaderboardModel({
    required this.totalInvest,
    required this.country,
    required this.totalUsers,
    required this.currentRank,
  });

  // Create an instance from JSON
  factory CountryLeaderboardModel.fromJson(Map<String, dynamic> json) {
    return CountryLeaderboardModel(
      totalInvest: json['totalInvest']?.toDouble() ?? 0.0,
      country: json['country'] ?? '',
      totalUsers: json['totalUsers']?.toInt() ?? 0,
      currentRank: json['currentRank']?.toInt() ?? 0,
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalInvest': totalInvest,
      'country': country,
      'totalUsers': totalUsers,
      'currentRank': currentRank,
    };
  }

  @override
  String toString() {
    return 'CountryLeaderboardModel(totalInvest: $totalInvest, country: $country, totalUsers: $totalUsers, currentRank: $currentRank)';
  }
}
