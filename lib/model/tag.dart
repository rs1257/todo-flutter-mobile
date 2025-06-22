import 'dart:ui';

import 'package:hive/hive.dart';

part '../adapter/tag.g.dart';

@HiveType(typeId: 1)
class Tag {
  @HiveField(0)
  String name;

  @HiveField(1)
  Color colour;

  Tag({required this.name, required this.colour});
}