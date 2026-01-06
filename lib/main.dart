import 'package:day_planner/start_page.dart';
import 'package:flutter/material.dart';
import 'package:day_planner/task_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required for async
  await TaskStorage.loadTasks(); // load saved tasks
  runApp(const MyApp());
}

void navigateTo(BuildContext context, Widget page, {int durationMs = 300}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: durationMs),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Start(),
      debugShowCheckedModeBanner: false,
    );
  }
}
