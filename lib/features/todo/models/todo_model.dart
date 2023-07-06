class TodoModel {
  int? id;
  String? name;
  int? coloreId;
  String? description;
  DateTime? date;

  TodoModel({
    required this.id,
    required this.name,
    required this.coloreId,
    required this.description,
    required this.date,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        name: json["name"],
        coloreId: json["coloreId"],
        description: json["description"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "coloreId": coloreId,
        "description": description,
        "date": date,
      };
}
