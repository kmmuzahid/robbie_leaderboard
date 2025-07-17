class ProfileResponseModel {
  final ProfileUserModel? user;
  final List<dynamic> investments;
  final int totalInvest;
  final List<dynamic> raisedBonuses;
  final int totalRaised;
  final RankInfoModel rankInfo;

  ProfileResponseModel({
    required this.user,
    required this.investments,
    required this.totalInvest,
    required this.raisedBonuses,
    required this.totalRaised,
    required this.rankInfo,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      user: json['user'] != null && json['user'] is Map
          ? ProfileUserModel.fromJson(json['user'])
          : null,
      investments: json['investments'] != null && json['investments'] is List
          ? json['investments']
          : [],
      totalInvest: json['totalInvest'] ?? 0,
      raisedBonuses: json['raisedBonuses'] ?? [],
      totalRaised: json['totalRaised'] ?? 0,
      rankInfo: RankInfoModel.fromJson(json['rankInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'investments': investments,
      'totalInvest': totalInvest,
      'raisedBonuses': raisedBonuses,
      'totalRaised': totalRaised,
      'rankInfo': rankInfo.toJson(),
    };
  }
}

class ProfileUserModel {
  final String id;
  final String name;
  final String email;
  final String contact;
  final String password;
  final String country;
  final String city;
  final String gender;
  final String age;
  final String role;
  final String status;
  final int views;
  final bool isDeleted;
  final int rank;
  final int raisedRank;
  final int totalInvest;
  final int totalRaised;
  final int totalReferredAmount;
  final int totalAdminAmount;
  final int withdraw;
  final String userCode;
  final List<dynamic> prevRank;
  final List<dynamic> prevRaisedRank;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String profileImg;
  final String facebook;
  final String instagram;
  final String twitter;
  final String linkedin;

  ProfileUserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.contact,
      required this.password,
      required this.country,
      required this.city,
      required this.gender,
      required this.age,
      required this.role,
      required this.status,
      required this.views,
      required this.isDeleted,
      required this.rank,
      required this.raisedRank,
      required this.totalInvest,
      required this.totalRaised,
      required this.totalReferredAmount,
      required this.totalAdminAmount,
      required this.withdraw,
      required this.userCode,
      required this.prevRank,
      required this.prevRaisedRank,
      required this.createdAt,
      required this.updatedAt,
      required this.v,
      this.profileImg = "",
      this.facebook = "",
      this.instagram = "",
      this.twitter = "",
      this.linkedin = ""});

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        contact: json['contact'],
        password: json['password'],
        country: json['country'],
        city: json['city'],
        gender: json['gender'],
        age: json['age'],
        role: json['role'],
        status: json['status'],
        views: json['views'],
        isDeleted: json['isDeleted'],
        rank: json['rank'],
        raisedRank: json['raisedRank'],
        totalInvest: json['totalInvest'],
        totalRaised: json['totalRaised'],
        totalReferredAmount: json['totalRefferedAmount'],
        totalAdminAmount: json['totalAdminAmount'],
        withdraw: json['withdraw'],
        userCode: json['userCode'],
        prevRank: json['prevRank'] ?? [],
        prevRaisedRank: json['prevRaisedRank'] ?? [],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        profileImg: json['profileImg'] ?? "",
        facebook: json['facebook'] ?? "",
        instagram: json['instagram'] ?? "",
        twitter: json['twitter'] ?? "",
        linkedin: json['linkedin'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'password': password,
      'country': country,
      'city': city,
      'gender': gender,
      'age': age,
      'role': role,
      'status': status,
      'views': views,
      'isDeleted': isDeleted,
      'rank': rank,
      'raisedRank': raisedRank,
      'totalInvest': totalInvest,
      'totalRaised': totalRaised,
      'totalRefferedAmount': totalReferredAmount,
      'totalAdminAmount': totalAdminAmount,
      'withdraw': withdraw,
      'userCode': userCode,
      'prevRank': prevRank,
      'prevRaisedRank': prevRaisedRank,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'linkedin': linkedin
    };
  }
}

class RankInfoModel {
  final int investRank;
  final List<dynamic> prevInvestRankHistory;
  final int raisedRank;
  final List<dynamic> prevRaisedRankHistory;

  RankInfoModel({
    required this.investRank,
    required this.prevInvestRankHistory,
    required this.raisedRank,
    required this.prevRaisedRankHistory,
  });

  factory RankInfoModel.fromJson(Map<String, dynamic> json) {
    return RankInfoModel(
      investRank: json['investRank'],
      prevInvestRankHistory: json['prevInvestRankHistory'] ?? [],
      raisedRank: json['raisedRank'],
      prevRaisedRankHistory: json['prevRaisedRankHistory'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'investRank': investRank,
      'prevInvestRankHistory': prevInvestRankHistory,
      'raisedRank': raisedRank,
      'prevRaisedRankHistory': prevRaisedRankHistory,
    };
  }
}
