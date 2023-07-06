import 'package:flutter/material.dart';

import '../models/colors_enum.dart';

class TaskTile extends StatelessWidget {
  final int? colorId;
  final String? taskTitle;
  final Function tabCallback;
  final Function longPressCallback;
  final String? timeLeft;
  const TaskTile({
    super.key,
    this.colorId,
    this.taskTitle,
    required this.tabCallback,
    required this.longPressCallback,
    this.timeLeft,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CircleAvatar(
          radius: 12,
          child: CircleAvatar(
              backgroundColor: TodoStatus.fromId(colorId ?? 0).color),
        ),
      ),
      onTap: () {
        tabCallback();
      },
      onLongPress: () {
        longPressCallback();
      },
      title: Text(
        taskTitle!,
      ),
      subtitle: Text(
        (timeLeft!),
        style: TextStyle(
            color: (timeLeft!) == 'Time Expired' ? Colors.red : Colors.green),
      ),
    );
  }
}
