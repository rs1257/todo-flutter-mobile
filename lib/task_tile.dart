import 'package:flutter/material.dart';
import 'package:todo/model/task.dart';

const double iconScale = 1.5;

class TaskTile extends StatefulWidget {
  const TaskTile({super.key, required this.task, this.onDelete});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Task task;
  final Function()? onDelete;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          isChecked = !isChecked!;
        });
      },
      leading: Transform.scale(
        scale: iconScale,
        child: Checkbox(
          checkColor: Colors.white,
          fillColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.blue.withOpacity(.32);
            }
            return Colors.blue;
          }),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        ),
      ),
      title: Text(widget.task.name, style: TextStyle(fontSize: 20),),
      subtitle: Text(widget.task.description, style: TextStyle(fontSize: 16)),
      tileColor: Colors.purple,
      textColor: Colors.white,
      trailing: Transform.scale(
        scale: iconScale,
        child: IconButton(icon: Icon(Icons.delete), onPressed: widget.onDelete),
      ),
    );
  }
}
