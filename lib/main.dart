// ignore_for_file: library_private_types_in_public_api

import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'core/get_it_register.dart';
import 'features/todo/datasource/todo_data_source.dart';
import 'main_screen.dart';

Future main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    await Alarm.init();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await GetItRegister.setupGetIt();

    runApp(
      const MyApp(),
    );
  } catch (err, stacktrace) {
    debugPrint(err.toString());
    debugPrint(stacktrace.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        home: const LoadingScreen(),
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    TaskData taskData = TaskData();
    taskData.getData().whenComplete(
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MainScreen();
              },
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    );
  }
}
