import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<String> _tasks = [];
  final List<bool> _checked = []; // List to manage checkbox states
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add(_controller.text);
        _checked.add(false); // Add a new checkbox state for the new task
        _controller.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _checked.removeAt(index); // Remove the checkbox state for the deleted task
    });
  }

  void _toggleCheckbox(int index, bool? value) {
    setState(() {
      _checked[index] = value ?? false; // Update the checkbox state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 209, 229, 245), // Pastel color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'My Tasks',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 209, 229, 245), // Pastel color
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  'assets/b.png', // Your small image
                  width: 100, // Increased width
                  height: 100, // Increased height
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                  color: Color.fromARGB(255, 209, 229, 245), // Pastel color
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Checkbox(
                        value: _checked[index], // Use the checkbox state
                        onChanged: (bool? value) {
                          _toggleCheckbox(index, value); // Toggle checkbox state
                        },
                      ),
                      title: Text(_tasks[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(index),
                        color: const Color.fromARGB(255, 204, 167, 198), // Pastel color
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}