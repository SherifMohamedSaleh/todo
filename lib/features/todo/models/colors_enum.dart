import 'package:flutter/material.dart';

enum TodoStatus {
  red(0, Colors.red),
  green(1, Colors.green),
  blue(2, Colors.blue),
  yellow(3, Colors.yellow),
  purple(4, Colors.purple),
  pink(5, Colors.pink),
  brown(6, Colors.brown);

  final int id;
  final Color color;
  const TodoStatus(this.id, this.color);

  static TodoStatus fromId(int id) {
    return TodoStatus.values.firstWhere((e) => e.id == id);
  }
}
