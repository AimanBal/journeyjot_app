import 'package:hive/hive.dart';

part 'user_model.g.dart'; // ✅ Hive needs this for code generation

@HiveType(typeId: 1) // ✅ Unique Hive type ID for UserModel
class UserModel extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password; // Consider hashing for better security

  UserModel({required this.email, required this.password});
}
