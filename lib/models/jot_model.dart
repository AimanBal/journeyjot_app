// models/jot_model.dart
import 'package:hive/hive.dart';

part 'jot_model.g.dart';

@HiveType(typeId: 0)
class JotModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String imagePath;

  @HiveField(4)
  DateTime dateTime;

  @HiveField(5)
  String userEmail; // ✅ Added this field

  JotModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.dateTime,
    required this.userEmail, // ✅ Added here
  });
}
