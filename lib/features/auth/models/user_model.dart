import 'image_model.dart';
import 'role_model.dart';

class User {
  int? id;
  String? name;
  String? email;
  List<Roles>? roles;
  Image? image;

  User({this.id, this.name, this.email, this.roles, this.image});

  static User fromJson(dynamic json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        roles: json['roles'] == null
            ? null
            : (json['roles'] as List).map((e) => Roles.fromJson(e)).toList(),
        image: json['image'] != null ? Image.fromJson(json['image']) : null);
  }

  dynamic toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'roles': roles?.map((v) => v.toJson()).toList(),
        'image': image!.toJson()
      };
}
