class OtpModel {
  final String otp;

  OtpModel({required this.otp});

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      otp: json['otp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
    };
  }
}
