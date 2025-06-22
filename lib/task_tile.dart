import 'package:flutter/material.dart';
import 'package:todo/model/task.dart';

const double iconScale = 1.5;

class TaskTile extends StatefulWidget {
  const TaskTile({super.key, required this.task, this.onDelete});

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
      subtitle: widget.task.description != "" ? Text(widget.task.description, style: TextStyle(fontSize: 16)) : null,
      tileColor: Colors.blueGrey,
      textColor: Colors.white,
      trailing: Transform.scale(
        scale: iconScale,
        child: IconButton(icon: Icon(Icons.delete), onPressed: widget.onDelete, color: Colors.red,),
      ),
    );
  }
}
