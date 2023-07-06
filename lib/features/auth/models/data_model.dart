import 'user_model.dart';

class Data {
  User? user;
  String? token;

  Data({this.user, this.token});

  static Data fromJson(dynamic json) {
    return Data(
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        token: json['token']);
  }

  dynamic toJson() => {
        'user': user!.toJson(),
        'token': token,
      };
}
