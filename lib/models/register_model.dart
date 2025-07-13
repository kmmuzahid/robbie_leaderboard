class RegisterModel {
  final String name;
  final String email;
  final String contact;
  final String password;
  final String country;
  final String city;
  final String gender;
  final String age;
  final String userCode;

  RegisterModel(
      {required this.name,
      required this.email,
      required this.contact,
      required this.password,
      required this.country,
      required this.city,
      required this.gender,
      required this.age,
      required this.userCode});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
        name: json['name'],
        email: json['email'],
        contact: json['contact'],
        password: json['password'],
        country: json['country'],
        city: json['city'],
        gender: json['gender'],
        age: json['age'],
        userCode: json['inviterCode']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'contact': contact,
      'password': password,
      'country': country,
      'city': city,
      'gender': gender,
      'age': age,
      'inviterCode': userCode
    };
  }
}
