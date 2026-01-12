import 'package:day_planner/about.dart';
import 'package:day_planner/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool autoClearTasks = true;
  bool addPlanDayTask = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      autoClearTasks = prefs.getBool('autoClearTasks') ?? true;
      addPlanDayTask = prefs.getBool('addPlanDayTask') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _resetTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tasks');
    tasksNotifier.value = [];
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All tasks have been reset!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 38, 38),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(
              'Auto-clear tasks at 9 PM',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            value: autoClearTasks,
            onChanged: (val) {
              setState(() {
                autoClearTasks = val;
                _saveSetting('autoClearTasks', val);
              });
            },
            activeColor: Colors.green, // ✅ green when on
            inactiveThumbColor: Colors.grey, // grey when off
          ),
          SwitchListTile(
            title: const Text(
              'Add "Plan Your Day" task at 9 PM',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            value: addPlanDayTask,
            onChanged: (val) {
              setState(() {
                addPlanDayTask = val;
                _saveSetting('addPlanDayTask', val);
              });
            },
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
          ),
          ListTile(
            title: const Text(
              'Reset all tasks',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            trailing: const Icon(Icons.refresh, color: Colors.white),
            onTap: _resetTasks,
          ),
          ListTile(
            title: const Text(
              'About',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onTap: () {
            navigateTo(context, AboutPage());
            },
          ),
        ],
      ),
    );
  }
}
