import 'package:hive/hive.dart';
import 'package:todo/model/priority.dart';
import 'package:todo/model/tag.dart';

part '../adapter/task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  bool isChecked = false;

  @HiveField(3)
  Priority? priority = Priority.none;

  @HiveField(4)
  Tag? tag;

  @HiveField(5)
  DateTime date;

  @HiveField(6)
  DateTime time;

  @HiveField(7)
  DateTime? repeatSchedule;

  @HiveField(8)
  bool? allDay;

  @HiveField(9)
  DateTime? reminder;

  Task({
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    this.reminder,
    this.repeatSchedule,
    this.allDay,
    this.priority,
    this.tag,
  });
}
