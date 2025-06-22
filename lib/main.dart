import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/add_task_bottom_sheet.dart';
import 'package:todo/model/tag.dart';
import 'package:todo/task_tile.dart';

import 'model/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Tag>('tags');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box<Task> taskBox;
  late Box<Tag> tagBox;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasks');
    tagBox = Hive.box<Tag>('tags');
  }

  @override
  void dispose() {
    super.dispose();
    taskBox.close();
    tagBox.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: [
          ListView.builder(
            itemCount: taskBox.length,
            itemBuilder: (context, index) {
              Task task = taskBox.getAt(index)!;
              return Card(
                child: TaskTile(
                  task: Task(
                    name: task.name,
                    description: task.description,
                    date: task.date,
                    time: task.time,
                  ),
                  onDelete: () {
                    taskBox.deleteAt(index);
                    setState(() {});
                  },
                ),
              );
            },
          ),
          Text("Tags"),
          Text("Settings"),
        ][currentPageIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showModalBottomSheet(
            context: context,
            builder: (builder) {
              return AddTaskBottomSheet(
                updateParentState: () {
                  setState(() {});
                },
              );
            },
          ),
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.label), label: 'Tags'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
