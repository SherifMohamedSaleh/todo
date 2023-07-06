import 'package:flutter/material.dart';
import 'package:todo_app/features/auth/screens/login_widget.dart';
import 'package:todo_app/features/todo/models/todo_model.dart';

import 'features/todo/screens/add_edit_todo_screen.dart';
import 'features/todo/screens/todo_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isAdd = false;

  bool islogin = false;

  TodoModel? todoModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO "),
        leading: IconButton(
          icon: const Icon(Icons.login),
          onPressed: () => {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              builder: (_) {
                return const LoginWidget();
              },
            ),
            islogin = !islogin
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isAdd = !isAdd;
            });
          },
          child: const Icon(
            Icons.add,
            size: 40,
          )),
      body: Stack(
        children: [
          TodoListScreen(
            tabCallback: (todo) {
              setState(() {
                todoModel = todo;
                isAdd = !isAdd;
              });
            },
          ),
          Visibility(
              visible: isAdd,
              child: TodoAddEditScreen(
                todoModel: todoModel,
                tabCallback: () {
                  setState(() {
                    isAdd = !isAdd;
                  });
                },
              )),
        ],
      ),
    );
  }
}
