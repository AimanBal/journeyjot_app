// screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart'; // ✅ Import for AppBackground

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      await Hive.openBox<UserModel>('usersBox'); // ✅ Ensure Hive is open
    }
    userBox = Hive.box<UserModel>('usersBox');

    print('Hive usersBox initialized: ${userBox.isOpen}'); // ✅ Debug log
  }

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password cannot be empty!')),
      );
      return;
    }

    // ✅ Check if user already exists
    if (userBox.containsKey(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User already exists! Try logging in.')),
      );
      return;
    }

    // ✅ Save new user to Hive
    final newUser = UserModel(email: email, password: password);
    await userBox.put(email, newUser);

    print('User registered: ${newUser.email}'); // ✅ Debug log for terminal

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Registration successful! You can now log in.')),
    );

    Navigator.pushReplacementNamed(
        context, '/login'); // ✅ Navigate to login screen
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      // ✅ Wraps entire screen with faded background
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // ✅ Center everything
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Getting started is easy! Create an account to save and revisit your moments anytime.",
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
                onPressed: _registerUser,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
