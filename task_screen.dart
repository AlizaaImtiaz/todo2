import 'package:flutter/material.dart';
import 'package:todo/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _taskController = TextEditingController();
  late final FirebaseFirestore _firestore;
  late final CollectionReference _tasksCollection;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      _firestore = FirebaseFirestore.instance;
      _tasksCollection = _firestore.collection('tasks');
      _loadTasks();
    });
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _tasksCollection.get();
      setState(() {
        _tasks = tasks.docs.map((doc) => Task(
          id: doc.id,
          title: doc['title'] ?? '',
          isCompleted: doc['isCompleted'] ?? false,
        )).toList();
      });
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> _addTask() async {
    try {
      await _tasksCollection.add({
        'title': _taskController.text,
        'isCompleted': false,
      });
      _taskController.clear();
      _loadTasks();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> _updateTask(Task task) async {
    try {
      await _tasksCollection.doc(task.id).update({
        'isCompleted': !task.isCompleted,
      });
      _loadTasks();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permission denied: $e');
      } else {
        print('Error updating task: $e');
      }
    }
  }

  Future<void> _deleteTask(Task task) async {
    try {
      await _tasksCollection.doc(task.id).delete();
      _loadTasks();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Add Task',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index].title),
                    trailing: Checkbox(
                      value: _tasks[index].isCompleted,
                      onChanged: (value) {
                        _updateTask(_tasks[index]);
                      },
                    ),
                    onLongPress: () {
                      _deleteTask(_tasks[index]);
                    },
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