import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:project/common/widget.dart';
import 'package:project/goals_folder/goals_screen.dart';
import 'package:project/graph_folder/graph_screen.dart';
import 'package:project/intake_folder/intake_screen.dart';
import 'package:project/profile_folder/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) =>
      MaterialApp(title: 'Health Tracker', theme: ThemeData(primarySwatch: Colors.blue), home: const FitnessApp());
}

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});
  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  final Map<String, DayData> dataMap = {};
  DateTime selectedDate = DateTime.now();
  int tabIndex = 3;
  Color tabColor = Colors.blue;
  bool isDisableSelectDate = false;
  bool isDisableBottomNav = true;


  String formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  DayData getDay(DateTime d) {
    final k = formatDate(d);
    dataMap[k] ??= DayData(dailyGoals: [], calorieIntake: 0, waterIntake: 0, weight: 0);
    return dataMap[k]!;
  }

