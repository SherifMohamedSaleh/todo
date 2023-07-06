import 'data_model.dart';

class LoginResponseModel {
  Data? data;
  bool? status;
  String? message;
  int? code;
  dynamic paginate;

  LoginResponseModel(
      {this.data, this.status, this.message, this.code, this.paginate});

  static LoginResponseModel fromJson(dynamic json) {
    return LoginResponseModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      status: json['status'],
      message: json['message'],
      code: json['code'],
      paginate: json['paginate'],
    );
  }

  dynamic toJson() => {
        'data': data?.toJson(),
        'status': status,
        'message': message,
        'code': code,
        'paginate': paginate,
      };
}
