import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/task_tile.dart';

import 'model/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasks');

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

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          taskBox.add(
            Task(
              name: "Test1${DateTime.timestamp()}",
              description: 'I am description',
              date: DateTime.timestamp(),
              time: DateTime.timestamp(),
            ),
          ),
          setState(() {}),
          showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Container(
                height: 350.0,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                    ),
                  ),
                  child: Center(child: Text("This is a modal sheet")),
                ),
              );
            },
          ),
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
