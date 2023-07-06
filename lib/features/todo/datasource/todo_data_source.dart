import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/features/todo/models/todo_model.dart';

List<TodoModel> _taskList = [];

class TaskData extends ChangeNotifier {
  List<String>? names = [];
  List<String>? dates = [];
  List<String>? uid = [];
  List<String>? colors = [];
  List<String>? descriptions = [];

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid!.clear();
    names!.clear();
    dates!.clear();
    colors!.clear();
    descriptions!.clear();

    _taskList.clear();
    uid = prefs.getStringList("id");
    names = prefs.getStringList("names");
    dates = prefs.getStringList("dates");
    colors = prefs.getStringList("colors");
    descriptions = prefs.getStringList("descriptions");

    if (names != null) {
      for (int i = 0; i < names!.length; i++) {
        _taskList.add(TodoModel(
            name: names![i],
            description: descriptions![i],
            coloreId: int.parse(colors![i]),
            date: DateTime.parse(dates![i]),
            id: int.parse(uid![i])));
      }
    }

    notifyListeners();
  }

  void setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid!.clear();
    names!.clear();
    dates!.clear();
    colors!.clear();
    descriptions!.clear();

    for (int i = 0; i < _taskList.length; i++) {
      names!.add(_taskList[i].name!);
      dates!.add(_taskList[i].date.toString());
      colors!.add(_taskList[i].coloreId.toString());
      descriptions!.add(_taskList[i].description.toString());
      uid!.add(_taskList[i].id.toString());
    }
    await prefs.setStringList("names", names!);
    await prefs.setStringList("descriptions", descriptions!);

    await prefs.setStringList("colors", colors!);

    await prefs.setStringList("dates", dates!);
    await prefs.setStringList("id", uid!);
    notifyListeners();
    setData();
  }

  UnmodifiableListView<TodoModel> get tasks {
    return UnmodifiableListView(_taskList);
  }

  void addTask(TodoModel model) {
    _taskList.add(TodoModel(
        name: model.name,
        date: model.date,
        id: model.id,
        coloreId: model.coloreId,
        description: model.description));
    setData();
    notifyListeners();
  }

  int get taskCount {
    return _taskList.length;
  }

  void deleteTask(TodoModel t) {
    _taskList.remove(t);
    setData();
    notifyListeners();
  }
}
