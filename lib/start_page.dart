import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:day_planner/add_task.dart';
import 'main.dart';
import 'task_data.dart';
import 'dart:convert';

class Task {
  String description;
  String startTime;
  String endTime;
  String category;

  Task({
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
  });

  // Convert Task to Map
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'category': category,
    };
  }

  // Convert Map to Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      description: map['description'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      category: map['category'],
    );
  }

  // Encode Task to JSON string
  String toJson() => json.encode(toMap());

  // Decode Task from JSON string
  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  final String todayDate = DateFormat('d MMM yyyy').format(DateTime.now());

  // LONG PRESS OPTIONS POPUP
  void _showTaskOptions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 38, 38, 38),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text(
                "Edit Task",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                navigateTo(context, AddTask());
                await TaskStorage.deleteTask(task);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                "Delete Task",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                Navigator.pop(context);
                await TaskStorage.deleteTask(task);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      // Top AppBar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 38, 38),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // your icon
            onPressed: () {
              //Navigator.push(context,MaterialPageRoute(builder: (context) => const AddTask()));
            },
          ),
        ],
        title: const Text(
          'Day Plan',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$todayDate\n',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ValueListenableBuilder<List<Task>>(
                valueListenable: tasksNotifier,
                builder: (context, tasks, _) {
                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text(
                        "No tasks added yet",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return GestureDetector(
                        onLongPress: () {
                          _showTaskOptions(context, task); // 👈 LONG PRESS
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${index + 1}. ${task.description}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "${task.startTime} - ${task.endTime}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 24,
              ), // minimal side gap
              child: SizedBox(
                width: double.infinity, // full screen width
                height: 52, // good button height
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 38, 38, 38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // slight curve
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    navigateTo(context, AddTask());
                  },

                  child: const Text(
                    '+ Add Task',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
