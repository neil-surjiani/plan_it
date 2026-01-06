import 'package:day_planner/start_page.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'task_data.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final List<String> timeIntervals = List.generate(48, (index) {
    final hour = index ~/ 2;
    final minute = (index % 2) * 30;

    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');

    return '$h:$m';
  });

  final List<String> categories = [
    'Productivity',
    'Entertainment',
    'Health',
    'Study',
    'Urgent',
    'Social',
    'Time Management'
  ];

  String category = 'Productivity';

  String startTime = '12:00';
  String endTime = '12:00';

  Widget dropdown({
    required List<String> items,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      // Dropdown list items
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),

      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((String item) {
          return Text(item, style: const TextStyle(color: Colors.white));
        }).toList();
      },

      // Triggered when user selects a new currency
      onChanged: onChanged,

      // Dropdown field decoration
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 43, 43),
      // Top AppBar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // your icon
          onPressed: () {
            navigateTo(context, Start());
          },
        ),
        backgroundColor: const Color.fromARGB(255, 38, 38, 38),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // your icon
            onPressed: () {
              //Navigator.push(context,MaterialPageRoute(builder: (context) => const NumGuess()));
            },
          ),
        ],
        title: const Text(
          'Add Tasks',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Description:',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            TextField(
              controller: controller, // Controls text input
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter activity description',
                hintStyle: const TextStyle(
                  color: Color.fromRGBO(135, 135, 135, 1),
                  fontSize: 17,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 38, 38, 38),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 24),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Start Time:',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: dropdown(
                    items: timeIntervals,
                    value: startTime,
                    onChanged: (value) {
                      setState(() {
                        startTime = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'End Time:',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: dropdown(
                    items: timeIntervals,
                    value: endTime,
                    onChanged: (value) {
                      setState(() {
                        endTime = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Category:',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: dropdown(
                    items: categories,
                    value: category,
                    onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

          SizedBox(height: 24),

            Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8), // minimal side gap
             child: SizedBox(
             width: double.infinity, // full screen width
             height: 52, // good button height
             child:TextButton(
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
              onPressed: () async {
                final newTask = Task(
                description: controller.text,
                startTime: startTime,
                endTime: endTime,
                category: category,
              );

              await TaskStorage.addTask(newTask);

              // Reset input fields (optional)
              controller.clear();
              startTime = '12:00';
              endTime = '12:00';
              category = 'Productivity';

              // Go back to Start page
              Navigator.pop(context);
},    
              child: const Text(
                'Save',
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

