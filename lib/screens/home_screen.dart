// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:journeyjot_app/screens/add_edit_jot_screen.dart';
import 'package:journeyjot_app/theme/app_theme.dart';
import '../models/jot_model.dart';
import '../models/user_model.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;

  const HomeScreen({super.key, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedMonth;
  late Box<JotModel> jotBox;

  @override
  void initState() {
    super.initState();

    if (!Hive.isBoxOpen('usersBox')) {
      Hive.openBox<UserModel>('usersBox');
    }
    if (!Hive.isBoxOpen('jotsBox')) {
      Hive.openBox<JotModel>('jotsBox');
    }

    final userBox = Hive.box<UserModel>('usersBox');
    jotBox = Hive.box<JotModel>('jotsBox');

    if (!userBox.isOpen || !jotBox.isOpen) {
      return;
    }

    final currentUser = userBox.get(widget.userEmail);
    if (currentUser == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
  }

  List<JotModel> _getFilteredJots() {
    final userJots = jotBox.values
        .where((jot) => jot.userEmail == widget.userEmail) // ✅ Filter by user
        .toList();

    return selectedMonth == null
        ? userJots
        : userJots.where((jot) => jot.dateTime.month == selectedMonth).toList();
  }

  String _monthName(int month) => DateFormat.MMMM().format(DateTime(0, month));

  void _openAddJotScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) =>
              AddEditJotScreen(jotId: null, userEmail: widget.userEmail)),
    ).then((_) => setState(() {}));
  }

  void _openProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ProfileScreen(userEmail: widget.userEmail)),
    );
  }

  void _confirmDelete(String jotId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Jot?'),
        content: const Text(
            'Are you sure you want to delete this jot? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              jotBox.delete(jotId);
              Navigator.pop(context);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jots = _getFilteredJots();

    if (widget.userEmail.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Error: No user email found')),
      );
    }

    return AppBackground(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Journey Jot',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: _openProfileScreen,
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<int>(
                value: selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Filter by Month',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('All Months')),
                  ...List.generate(12, (index) {
                    final month = index + 1;
                    return DropdownMenuItem(
                      value: month,
                      child: Text(_monthName(month)),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value;
                  });
                },
              ),
            ),
            Expanded(
              child: jots.isEmpty
                  ? const Center(child: Text('No jots yet. Start writing!'))
                  : ListView.builder(
                      itemCount: jots.length,
                      itemBuilder: (context, index) {
                        final jot = jots[index];

                        return ListTile(
                          title: Text(
                            jot.title, // ✅ Now showing title instead of full description
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jot.description.length > 15
                                    ? '${jot.description.substring(0, 15)}...'
                                    : jot
                                        .description, // ✅ Show only the first 20 characters
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                              Text(
                                DateFormat.yMMMd().format(jot.dateTime),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue), // ✏️ Edit Icon
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditJotScreen(
                                          jotId: jot.id,
                                          userEmail: widget.userEmail),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red), // 🗑️ Delete Icon
                                onPressed: () => _confirmDelete(jot.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddJotScreen,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
