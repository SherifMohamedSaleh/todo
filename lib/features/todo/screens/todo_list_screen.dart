import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/dialog_function.dart';
import '../models/todo_model.dart';
import '../datasource/todo_data_source.dart';
import 'item_tile.dart';

class TodoListScreen extends StatelessWidget {
  final Function(TodoModel todo) tabCallback;
  const TodoListScreen({
    Key? key,
    required this.tabCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [
                0.1,
                0.3,
                0.7,
              ],
              colors: [
                Colors.cyan.withAlpha(100),
                Colors.pink.withAlpha(20),
                Colors.white,
              ],
            ),
          ),
          child: Provider.of<TaskData>(context).taskCount == 0
              ? Center(
                  child: Text(
                      "No Data Todo ${Provider.of<TaskData>(context).taskCount} Tasks"))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return TaskTile(
                      colorId: taskData.tasks[index].coloreId,
                      taskTitle: taskData.tasks[index].name,
                      timeLeft: taskData.tasks[index].date.toString(),
                      longPressCallback: () {
                        CustomDialogs.showConfirm(
                          confirmMsg:
                              "are you sure you want to remove this alarm",
                          context: context,
                          onOkFunction: () {
                            taskData.deleteTask(taskData.tasks[index]);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      tabCallback: () {
                        tabCallback(taskData.tasks[index]);
                      },
                    );
                  },
                  itemCount: Provider.of<TaskData>(context).taskCount),
        );
      },
    );
  }
}
