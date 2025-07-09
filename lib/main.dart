// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/jot_model.dart';
import 'models/user_model.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // ✅ Initialize Hive first
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(JotModelAdapter());

  // ✅ Manually ensure boxes open before running the app
  await openHiveBoxes();

  runApp(const JJApp());
}

// ✅ This method guarantees Hive opens ALL boxes before the app starts
Future<void> openHiveBoxes() async {
  try {
    await Hive.openBox<UserModel>('usersBox');
    await Hive.openBox<JotModel>('jotsBox');
    await Hive.openBox('settingsBox');

    print('✅ All Hive boxes opened successfully!');
  } catch (e) {
    print('❌ Hive failed to open boxes: $e');
  }
}

class JJApp extends StatelessWidget {
  const JJApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journey Jot',
      theme: AppTheme.lightTheme,
      initialRoute: '/login', // ✅ Start the app on the login screen
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) {
          final String? userEmail =
              ModalRoute.of(context)?.settings.arguments as String?;
          return userEmail != null
              ? HomeScreen(userEmail: userEmail)
              : const LoginScreen();
        },
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('usersBox')) {
      return const LoginScreen(); // ✅ Ensure usersBox is open before proceeding
    }
    if (!Hive.isBoxOpen('settingsBox')) {
      return const LoginScreen(); // ✅ Ensure settingsBox is open before proceeding
    }

    final settingsBox = Hive.box('settingsBox');
    final String? userEmail = settingsBox.get('currentUserEmail') as String?;

    if (userEmail == null) {
      return const LoginScreen(); // ✅ Redirect if no user is logged in
    }

    final userBox = Hive.box<UserModel>('usersBox');
    final UserModel? currentUser = userBox.get(userEmail);

    return currentUser != null
        ? HomeScreen(userEmail: currentUser.email) // ✅ Pass userEmail correctly
        : const LoginScreen();
  }
}
