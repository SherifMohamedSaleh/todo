// ignore_for_file: must_be_immutable

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/features/todo/screens/todo_alarm_notify_screen.dart';
import 'package:todo_app/features/todo/datasource/todo_data_source.dart';
import 'package:todo_app/features/todo/models/todo_model.dart';

import 'dart:async';

import '../../../core/app_widget.dart';
import '../models/colors_enum.dart';

import 'package:intl/intl.dart' as intl;

class TodoAddEditScreen extends StatefulWidget {
  final Function tabCallback;
  late AlarmSettings alarmSettings;
  final TodoModel? todoModel;

  TodoAddEditScreen({
    Key? key,
    required this.tabCallback,
    this.todoModel,
  }) : super(key: key);

  @override
  State<TodoAddEditScreen> createState() => _TodoAddEditScreenState();
}

class _TodoAddEditScreenState extends State<TodoAddEditScreen>
    with SingleTickerProviderStateMixin {
  // animation
  late double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  bool isLeftCollapsed = true;
  bool isRightCollapsed = true;

// list of alarms
  late List<AlarmSettings> alarms;
  static StreamSubscription? subscription;
  late bool creating;

  late TimeOfDay selectedTime;
  DateTime selectedDate = DateTime.now();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  resetControllers() {
    titleController.clear();
    bodyController.clear();
    dateController.clear();
    timeController.clear();
  }

  int coloreId = 1;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<TodoStatus> colors = [
    TodoStatus.red,
    TodoStatus.green,
    TodoStatus.blue,
    TodoStatus.yellow,
    TodoStatus.purple,
    TodoStatus.pink,
    TodoStatus.brown
  ];

  TodoStatus seletedColor = TodoStatus.red;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: duration);

    loadAlarms();

    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );

// to add animation
    Future.delayed(duration, () {
      setState(() {
        if (isLeftCollapsed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        isLeftCollapsed = !isLeftCollapsed;
      });
    });

    creating = widget.todoModel == null;

    if (creating) {
      final dt = DateTime.now().add(const Duration(minutes: 1));
      selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
    } else {
      titleController.text = widget.todoModel?.name ?? "";
      bodyController.text = widget.todoModel?.description ?? "";

      DateTime date = DateTime(
        widget.todoModel?.date?.year ?? DateTime.now().year,
        widget.todoModel?.date?.month ?? DateTime.now().month,
        widget.todoModel?.date?.day ?? DateTime.now().day,
        widget.todoModel?.date?.hour ?? 0,
        widget.todoModel?.date?.minute ?? 0,
      );
      dateController.text =
          intl.DateFormat('yyyy-MM-dd').format(date).toString();

      selectedTime = TimeOfDay(
        hour: widget.todoModel?.date?.hour ?? 0,
        minute: widget.todoModel?.date?.minute ?? 0,
      );

      timeController.text = intl.DateFormat('hh-mm-aa').format(date).toString();

      // time.toString()
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    subscription?.cancel();
    super.dispose();
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExampleAlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
      for (var element in alarms) {
        if (element.notificationTitle == widget.todoModel?.name) {
          widget.alarmSettings = AlarmSettings(
              id: element.id,
              dateTime: element.dateTime,
              assetAudioPath: element.assetAudioPath);
        }
      }
    });
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: selectedTime,
      context: context,
    );
    if (res != null) setState(() => selectedTime = res);
  }

  AlarmSettings buildAlarmSettings(int id, String title, String body) {
    final now = DateTime.now();

    DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
      0,
      0,
    );
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(const Duration(days: 1));
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: false,
      vibrate: true,
      notificationTitle: title,
      notificationBody: body,
      assetAudioPath: 'assets/marimba.mp3',
      stopOnNotificationOpen: false,
    );
    return alarmSettings;
  }

  void updateAlarm() {
    deleteAlarm(true);
    saveAlarm();
  }

  void saveAlarm() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 1000000
        : widget.todoModel!.id!;
    Alarm.set(
            alarmSettings: buildAlarmSettings(
                id, titleController.text, bodyController.text))
        .then((res) {
      if (res) {
        Provider.of<TaskData>(context, listen: false).addTask(TodoModel(
            id: id,
            name: titleController.text,
            coloreId: coloreId,
            description: bodyController.text,
            date: DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
              0,
              0,
            )));

        resetControllers();
        widget.tabCallback();
      }
    });
  }

  void deleteAlarm(bool isUpdate) {
    Alarm.stop(widget.alarmSettings.id).then((value) {
      Provider.of<TaskData>(context, listen: false)
          .deleteTask(widget.todoModel!);
      subscription?.cancel();
    });
  }

  validateFieldNotEmpty(String? value, String error) {
    if (value == null || value.isEmpty == true || value.trim().isEmpty) {
      return error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return AnimatedPositioned(
      left: isLeftCollapsed ? 0 : 0.2 * screenWidth,
      right: isRightCollapsed ? 0 : -0.2 * screenWidth,
      duration: duration,
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              bottomLeft: Radius.circular(32),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                bottomLeft: Radius.circular(32),
              ),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: const [
                  0.1,
                  0.4,
                  0.9,
                ],
                colors: [
                  Colors.cyan.withAlpha(20),
                  Colors.white,
                  Colors.cyan.withAlpha(20),
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            coloreId = colors[index].id;
                            seletedColor = colors[index];
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            radius: 20,
                            foregroundColor: seletedColor.id == colors[index].id
                                ? Colors.white
                                : Colors.black,
                            child: Container(
                                margin: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                    backgroundColor: colors[index].color)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text(
                        "name",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppWidgets.textFormField(
                        keyValue: "name",
                        maxLength: 300,
                        controller: titleController,
                        labelText: "name",
                        validator: (value) => validateFieldNotEmpty(
                          value,
                          "name",
                        ),
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.textsms,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AppWidgets.textFormField(
                        keyValue: "Description",
                        controller: bodyController,
                        obscureText: false,
                        maxLength: 500,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        labelText: "Description",
                        validator: (value) =>
                            validateFieldNotEmpty(value, "Description"),
                      ),
                      const Text(
                        "Date",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();

                          DateTime today = DateTime.now();

                          if (dateController.text.isNotEmpty) {
                            intl.DateFormat('yyyy-MM-dd')
                                .parse(dateController.text);
                          }

                          selectedDate = (await showDatePicker(
                            context: context,
                            currentDate: selectedDate,
                            initialDate: today,
                            firstDate: today,
                            lastDate: today.add(const Duration(days: 60)),
                          ))!;

                          dateController.text = intl.DateFormat('yyyy-MM-dd')
                              .format(selectedDate)
                              .toString();
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: AbsorbPointer(
                                child: AppWidgets.textFormField(
                                  prefixIcon: Icons.calendar_month,
                                  keyValue: "missingDate",
                                  controller: dateController,
                                  labelText: "Date ",
                                  validator: (value) {
                                    validateFieldNotEmpty(
                                        value, "missing Date");

                                    if (dateController.text.trim().isNotEmpty) {
                                      intl.DateFormat('yyyy-MM-dd')
                                          .parse(value!);
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "Time",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();

                          if (dateController.text.isNotEmpty) {
                            intl.DateFormat('yyyy-MM-dd')
                                .parse(dateController.text);
                          }

                          TimeOfDay? res = await showTimePicker(
                            initialTime: selectedTime,
                            context: context,
                          );

                          if (res != null) {
                            setState(() {
                              selectedTime = res;
                              timeController.text =
                                  selectedTime.format(context);
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: AbsorbPointer(
                                child: AppWidgets.textFormField(
                                  prefixIcon: Icons.alarm,
                                  keyValue: "missingTime",
                                  controller: timeController,
                                  labelText: "Time",
                                  validator: (value) {
                                    validateFieldNotEmpty(
                                        value, "Missing Time");

                                    if ((value == null ||
                                        value.trim().isEmpty)) {
                                      return "missing Time";
                                    }

                                    if (timeController.text.trim().isNotEmpty) {
                                      timeController.text =
                                          selectedTime.format(context);
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (creating) {
                          saveAlarm();
                        } else {
                          updateAlarm();
                        }
                      },
                      child: Text(
                        creating ? "Save" : "update",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.blueAccent),
                      ),
                    ),
                    if (!creating)
                      TextButton(
                        onPressed: () => deleteAlarm(false),
                        child: Text(
                          'Delete Alarm',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.red),
                        ),
                      ),
                  ],
                ),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
