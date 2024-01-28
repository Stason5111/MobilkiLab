import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';
import 'main.dart';



class TaskRepository {
  Future<Brightness> loadBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBrightness = prefs.getString('brightness') ?? 'light';
    return savedBrightness == 'light' ? Brightness.light : Brightness.dark;
  }

  Future<void> saveBrightness(Brightness brightness) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('brightness', brightness == Brightness.light ? 'light' : 'dark');
  }

  Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList('tasks') ?? [];
    return taskList.map((task) => Task.fromJson(task)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) => task.toJson()).toList();
    await prefs.setStringList('tasks', taskList);
  }
}
