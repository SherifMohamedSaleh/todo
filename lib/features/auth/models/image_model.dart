class Image {
  int? id;
  int? imageableId;
  String? imageableType;
  String? path;
  String? fullPath;
  int? order;

  Image(
      {this.id,
      this.imageableId,
      this.imageableType,
      this.path,
      this.fullPath,
      this.order});

  static Image fromJson(dynamic json) {
    return Image(
      id: json['id'],
      imageableId: json['imageable_id'],
      imageableType: json['imageable_type'],
      path: json['path'],
      fullPath: json['full_path'],
      order: json['order'],
    );
  }

  dynamic toJson() => {
        'id': id,
        'imageable_id': imageableId,
        'imageable_type': imageableType,
        'path': path,
        'full_path': fullPath,
        'order': order,
      };
}
