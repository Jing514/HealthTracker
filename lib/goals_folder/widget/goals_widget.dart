import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// final dbRef = FirebaseDatabase.instance.ref();

class GoalItem {
  String? id;
  final String title;
  bool completed;
  GoalItem(this.title, this.completed, {this.id});
}

class GoalsWidget extends StatefulWidget {
  final DateTime date;
  final String goalText;
  final bool isFinish;

  const GoalsWidget({
    super.key,
    required this.date,
    required this.goalText,
    required this.isFinish,
  });

  @override
  State<GoalsWidget> createState() => _GoalsWidgetState();
}

class _GoalsWidgetState extends State<GoalsWidget> {
  final _goalController = TextEditingController();
  final List<GoalItem> dailyGoals = [];

  String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _goalController.text = widget.goalText;
  }

  // reload list if parent passes a new date
  @override
  void didUpdateWidget(covariant GoalsWidget old) {
    super.didUpdateWidget(old);
    if (_dayKey(old.date) != _dayKey(widget.date)) {
      _goalController.clear();
    }
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final completed = dailyGoals.where((g) => g.completed).length;
    final double rate = dailyGoals.isEmpty ? 0 : completed / dailyGoals.length;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: dailyGoals.length,
            itemBuilder: (_, i) {
              final g = dailyGoals[i];
              return Container(
                color: g.completed
                    ? Colors.transparent
                    : Colors.red.withOpacity(0.3),
                child: CheckboxListTile(
                  title: Text(g.title),
                  value: g.completed,
                  onChanged: (v) {
                    setState(() => g.completed = v ?? false);
                    // save goal g
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text('Completion Rate: ${(rate * 100).toStringAsFixed(0).padLeft(3," ")}%'),
        LinearProgressIndicator(value: rate),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _goalController,
                decoration: const InputDecoration(
                  labelText: 'Enter daily goal',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final text = _goalController.text.trim();
                if (text.isEmpty) return;
                setState(() {
                  final g = GoalItem(text, widget.isFinish);
                  dailyGoals.add(g);
                  _goalController.clear();
                  // save goal g
                });
              },
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
