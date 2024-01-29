import 'package:flutter/material.dart';
import 'task_repository.dart';
import 'task.dart';

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
  late List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();
  final TaskRepository _taskRepository = TaskRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    Brightness brightness = await _taskRepository.loadBrightness();
    List<Task> loadedTasks = await _taskRepository.loadTasks();

    setState(() {
      _brightness = brightness;
      tasks = loadedTasks;
    });
  }

  Future<void> _saveData() async {
    await _taskRepository.saveBrightness(_brightness);
    await _taskRepository.saveTasks(tasks);
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


