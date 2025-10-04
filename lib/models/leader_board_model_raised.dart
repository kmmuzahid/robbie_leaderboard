class LeaderBoardModelRaised {
  final String userId;
  final String name;
  final String profileImg;
  final num totalRaised;
  final int currentRaisedRank;
  final int previousRaisedRank;
  final int totalView;

  LeaderBoardModelRaised({
    required this.userId,
    required this.name,
    required this.profileImg,
    required this.totalRaised,
    required this.currentRaisedRank,
    required this.previousRaisedRank,
    required this.totalView,
  });

  factory LeaderBoardModelRaised.fromJson(Map<String, dynamic> json) {
    return LeaderBoardModelRaised(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      profileImg: json['profileImg'] ?? '',
      totalRaised:  json['totalRaised'] ?? 0.0,
      currentRaisedRank: json['currentRaisedRank'] ?? 0,
      previousRaisedRank: json['previousRaisedRank'] ?? 0,
      totalView: json['totalView'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'profileImg': profileImg,
      'totalRaised': totalRaised,
      'currentRank': currentRaisedRank,
      'previousRank': previousRaisedRank,
      'totalView': totalView,
    };
  }

  factory LeaderBoardModelRaised.empty() => LeaderBoardModelRaised(
        userId: '',
        name: '',
        totalRaised: 0.0,
        currentRaisedRank: 0,
        previousRaisedRank: 0,
        profileImg: 'Unknown',
        totalView: 0,
      );
}
