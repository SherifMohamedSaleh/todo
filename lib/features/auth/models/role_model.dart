class Roles {
  int? id;
  String? name;

  Roles({this.id, this.name});

  static Roles fromJson(dynamic json) {
    return Roles(
      id: json['id'],
      name: json['name'],
    );
  }

  dynamic toJson() => {
        'id': id,
        'name': name,
      };
}
