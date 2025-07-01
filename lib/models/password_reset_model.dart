class PasswordResetModel {
  final String id;
  final String newPassword;

  PasswordResetModel({
    required this.id,
    required this.newPassword,
  });

  factory PasswordResetModel.fromJson(Map<String, dynamic> json) {
    return PasswordResetModel(
      id: json['id'],
      newPassword: json['newPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'newPassword': newPassword,
    };
  }
}
