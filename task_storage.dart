import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task.dart';

class TaskStorage {
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = tasks.map((task) => json.encode({
      'title': task.title,
      'isCompleted': task.isCompleted,
    })).toList();
    await prefs.setStringList('tasks', taskStrings);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? taskStrings = prefs.getStringList('tasks');
    if (taskStrings == null) return [];
    return taskStrings.map((taskString) {
      final taskMap = json.decode(taskString);
      return Task(
        title: taskMap['title'],
        isCompleted: taskMap['isCompleted'], id: '',
      );
    }).toList();
  }
}