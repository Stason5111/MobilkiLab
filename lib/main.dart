import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  Brightness _brightness = Brightness.light;
  bool _brightnessInitialized = false; // Новая переменная для отслеживания инициализации _brightness
  late List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBrightness = prefs.getString('brightness') ?? 'light';

    if (!_brightnessInitialized) {
      setState(() {
        _brightness = savedBrightness == 'light' ? Brightness.light : Brightness.dark;
        _brightnessInitialized = true;
      });
    }

    List<String> taskList = prefs.getStringList('tasks') ?? [];
    setState(() {
      tasks = taskList.map((task) => Task.fromJson(task)).toList();
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('brightness', _brightness == Brightness.light ? 'light' : 'dark');

    List<String> taskList = tasks.map((task) => task.toJson()).toList();
    prefs.setStringList('tasks', taskList);
  }

  void _toggleBrightness() {
    setState(() {
      _brightness = _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: Text('To-Do List'),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: _toggleBrightness,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index].name),
                    trailing: Checkbox(
                      value: tasks[index].isDone,
                      onChanged: (value) {
                        setState(() {
                          tasks[index].isDone = value ?? false;
                          _saveData();
                        });
                      },
                    ),
                    onLongPress: () {
                      setState(() {
                        tasks.removeAt(index);
                        _saveData();
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      onSubmitted: (task) {
                        setState(() {
                          tasks.add(Task(task));
                          taskController.clear();
                          _saveData();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Add a new task...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        tasks.add(Task(taskController.text));
                        taskController.clear();
                        _saveData();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String name;
  bool isDone;

  Task(this.name, {this.isDone = false});

  Task.fromJson(String json) : name = json.split("###")[0], isDone = json.split("###")[1] == "true";

  String toJson() {
    return "$name###$isDone";
  }
}
