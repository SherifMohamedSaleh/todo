class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  dynamic toJson() => {
        'email': email,
        'password': password,
      };

  static LoginRequestModel fromJson(dynamic json) {
    return LoginRequestModel(
      email: json?['email'],
      password: json?['password'],
    );
  }
}
