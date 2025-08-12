import 'package:flutter/material.dart';
import 'package:project/goals_folder/widget/goals_widget.dart';

class GoalsScreen extends StatelessWidget {
  final DateTime date;

  const GoalsScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final dayKey = '${date.year}-${date.month}-${date.day}';   // calendar-day key

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: const Center(
            child: Text(
              'Daily Goals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GoalsWidget(
              key: ValueKey(dayKey),        // forces new state everyday
              date: date,
              goalText: '',
              isFinish: false,
            ),
          ),
        ),
      ],
    );
  }
}