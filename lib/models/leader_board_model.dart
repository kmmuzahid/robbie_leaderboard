class LeaderBoardModel {
  final String userId;
  final String name;
  final String profileImg;
  final num totalInvest;
  final int currentRank;
  final int previousRank;
  final int totalView;

  LeaderBoardModel({
    required this.userId,
    required this.name,
    required this.profileImg,
    required this.totalInvest,
    required this.currentRank,
    required this.previousRank,
    required this.totalView,
  });

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    return LeaderBoardModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      profileImg: json['profileImg'] ?? '',
      totalInvest:  json['totalInvest'] ?? 0.0,
      currentRank: json['currentRank'] ?? 0,
      previousRank: json['previousRank'] ?? 0,
      totalView: json['totalView'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profileImg': profileImg,
      'totalInvest': totalInvest,
      'currentRank': currentRank,
      'previousRank': previousRank,
      'totalView': totalView,
    };
  }

  factory LeaderBoardModel.empty() => LeaderBoardModel(
        userId: '',
        name: '',
        totalInvest: 0.0,
        currentRank: 0,
        previousRank: 0,
        profileImg: 'Unknown',
        totalView: 0,
      );
}
