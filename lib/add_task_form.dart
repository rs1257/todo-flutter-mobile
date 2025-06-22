import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/util/capitalise.dart';

import 'model/priority.dart';
import 'model/task.dart';

// Define a custom Form widget.
class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key, required this.updateParentState});

  final Function() updateParentState;

  @override
  AddTaskFormState createState() {
    return AddTaskFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddTaskFormState extends State<AddTaskForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();

  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasks');
  }

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: taskNameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.add_task),
              hintText: 'What should we call this task?',
              labelText: 'Task Name *',
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: taskDescriptionController,
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              hintText: 'Can you describe this task?',
              labelText: 'Task Description',
            ),
          ),
          DropdownButtonFormField(
            value: Priority.none,
            items: Priority.values.map((priority) {
              return DropdownMenuItem<Priority>(
                value: priority,
                child: Text(priority.name.capitalise()),
              );
            }).toList(),
            onChanged: (value) {
              // Handle priority change
            },
            decoration: const InputDecoration(
              icon: Icon(Icons.priority_high),
              labelText: 'Priority',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                taskBox.add(
                  Task(
                    name: taskNameController.text,
                    description: taskDescriptionController.text,
                    date: DateTime.timestamp(),
                    time: DateTime.timestamp(),
                  ),
                );
                widget.updateParentState();
                // Close the bottom sheet after adding the task
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// TODO need to add the following to the form
// Tag? tag;
// DateTime date;
// DateTime time;
// DateTime? repeatSchedule;
// bool? allDay;
// DateTime? reminder;

// TODO need to implement the notion of tags.
// TODO need to implement the notion of reminders.
// TODO need to implement the notion of repeat schedules.
// TODO need to an area for completed tasks.
// TODO decide on colours and themes for the app.
