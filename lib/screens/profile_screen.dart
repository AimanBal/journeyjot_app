// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:journeyjot_app/models/user_model.dart';
import 'login_screen.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final String userEmail;

  const ProfileScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('settingsBox')) {
      return const LoginScreen(); // ✅ Ensure settingsBox is available
    }

    final settingsBox = Hive.box('settingsBox');
    final userEmailFromSettings =
        settingsBox.get('currentUserEmail') as String?;
    final userBox = Hive.box<UserModel>('usersBox');
    final currentUser = userEmailFromSettings != null
        ? userBox.get(userEmailFromSettings)
        : null;

    final bool isLoggedIn = currentUser != null;
    final String userId = currentUser?.email ?? 'Guest';

    return AppBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: isLoggedIn
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // ✅ Center vertically
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // ✅ Center horizontally
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'User ID: $userId',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center, // ✅ Center text
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Email: $userEmail',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center, // ✅ Center text
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () async {
                        settingsBox
                            .delete('currentUserEmail'); // ✅ Clears session
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (Route<dynamic> route) =>
                              false, // ✅ Ensures logout is final
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent, // ✅ Stand-out button
                      ),
                    ),
                  ],
                ),
              )
            : const Center(child: Text('No user logged in.')),
      ),
    );
  }
}
