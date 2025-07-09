// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:journeyjot_app/theme/app_theme.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Box<UserModel> userBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    if (!Hive.isBoxOpen('usersBox')) {
      await Hive.openBox<UserModel>(
          'usersBox'); // ✅ Ensure Hive box is opened before login
    }
    userBox = Hive.box<UserModel>('usersBox');
  }

  Future<void> _signIn() async {
    if (!Hive.isBoxOpen('usersBox')) {
      await Hive.openBox<UserModel>('usersBox'); // ✅ Ensure box is opened
    }
    if (!Hive.isBoxOpen('settingsBox')) {
      await Hive.openBox('settingsBox'); // ✅ Ensure box is opened
    }

    final userBox = Hive.box<UserModel>('usersBox');
    final settingsBox = Hive.box('settingsBox');

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password cannot be empty!')),
      );
      return;
    }

    final existingUser = userBox.get(email);
    if (existingUser != null && existingUser.password == password) {
      settingsBox.put('currentUserEmail', email); // ✅ Overwrites last email
      Navigator.pushReplacementNamed(context, '/home', arguments: email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // ✅ Center content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // ✅ Align everything properly
            children: [
              const Text(
                "Welcome to Journey Jot! Start capturing your moments—sign in or create an account to begin.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // ✅ Adds spacing after the message
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signIn,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
