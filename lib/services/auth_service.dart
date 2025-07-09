// services/auth_service.dart
import 'package:hive/hive.dart';

class AuthService {
  final Box userBox = Hive.box('userBox');

  Stream<bool> get userChanges async* {
    yield userBox.get('isLoggedIn', defaultValue: false);
  }

  Future<void> signInLocally() async {
    userBox.put('isLoggedIn', true);
    userBox.put('userId', DateTime.now().millisecondsSinceEpoch.toString()); // Assign a local unique ID
  }

  Future<void> signOut() async {
    userBox.put('isLoggedIn', false);
    userBox.delete('userId');
  }
}
