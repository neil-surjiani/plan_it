import 'package:flutter/material.dart';
import 'start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<List<Task>> tasksNotifier = ValueNotifier([]);

class TaskStorage {
  static const String key = 'tasks';
  static const String lastClearKey = 'lastClear'; // tracks last daily reset

  // Load tasks from shared preferences
  static Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final ninePmToday = DateTime(
      now.year,
      now.month,
      now.day,
      21,
      0,
    ); // 9:00 PM

    final lastClearStr = prefs.getString(lastClearKey);
    bool shouldClear = false;

    if (lastClearStr == null) {
      // First app launch ever
      shouldClear = true;
    } else {
      final lastClear = DateTime.parse(lastClearStr);

      // If it's past 9 PM and we haven't cleared today yet
      if (now.isAfter(ninePmToday) && lastClear.isBefore(ninePmToday)) {
        shouldClear = true;
      }
    }

    if (shouldClear) {
      // 1️⃣ Clear old tasks
      tasksNotifier.value = [];

      // 2️⃣ Add "Plan Your Day" task
      final planTask = Task(
        description: 'Plan Your Day',
        startTime: '21:00',
        endTime: '21:15',
        category: 'Time Management',
      );

      tasksNotifier.value = [planTask];

      // 3️⃣ Save tasks
      await saveTasks();

      // 4️⃣ Update last clear time
      await prefs.setString(lastClearKey, now.toIso8601String());

      return; // IMPORTANT: stop further loading
    }

    // Normal load (no clearing needed)
    final List<String>? tasksJson = prefs.getStringList(key);
    if (tasksJson != null) {
      final loadedTasks = tasksJson.map((e) => Task.fromJson(e)).toList();

      // SORT BY START TIME ⏱️
      loadedTasks.sort((a, b) => a.startTime.compareTo(b.startTime));

      tasksNotifier.value = loadedTasks;
    }
  }

  // Save tasks to shared preferences
  static Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasksJson = tasksNotifier.value
        .map((task) => task.toJson())
        .toList();
    await prefs.setStringList(key, tasksJson);
  }

  // Add a task and save immediately
  static Future<void> addTask(Task task) async {
    final updatedTasks = [...tasksNotifier.value, task];

    // SORT BY START TIME ⏱️
    updatedTasks.sort((a, b) => a.startTime.compareTo(b.startTime));

    tasksNotifier.value = updatedTasks;
    await saveTasks();
  }
  
  // DELETE TASK
static Future<void> deleteTask(Task task) async {
  final updatedTasks = tasksNotifier.value
      .where((t) =>
          t.description != task.description ||
          t.startTime != task.startTime ||
          t.endTime != task.endTime)
      .toList();

  tasksNotifier.value = updatedTasks;
  await saveTasks();
}

}
