// widgets/jot_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JotCard extends StatelessWidget {
  final Map<String, dynamic> jotData;
  final VoidCallback onTap;

  const JotCard({
    super.key,
    required this.jotData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = jotData['dateTime'] as DateTime;
    final title = jotData['title'] ?? 'Untitled'; // ✅ Show title
    final description = jotData['description'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title, // ✅ Display title
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description.length > 15
                  ? '${description.substring(0, 15)}...'
                  : description, // ✅ Show only a short version of description
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat('yyyy-MM-dd – kk:mm').format(dateTime),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
