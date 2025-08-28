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


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Daily Objectives'),
          content: const Text('Remember to complete your daily goals!'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      GoalsScreen(date: selectedDate),
      GraphScreen(date: selectedDate),
      IntakeScreen(date: selectedDate),
      ProfileScreen(openBottomNav: (){
        setState(() {
          isDisableBottomNav = false;
        });
      },),
    ];

    return Theme(
      data: ThemeData(primarySwatch: createMaterialColor(tabColor)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          if (tabIndex != 3)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(icon: const Icon(Icons.arrow_left), onPressed: isDisableSelectDate?null:(){
                  setState((){
                    selectedDate = selectedDate.subtract(const Duration(days: 1));
                    isDisableSelectDate = true;
                  });
                  Future.delayed(Duration(seconds: 4),(){
                    setState(() {
                      isDisableSelectDate = false;
                    });
                  });
                }),
                Text(formatDate(selectedDate), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.arrow_right), onPressed: isDisableSelectDate?null:(){
                  setState((){
                    selectedDate = selectedDate.add(const Duration(days: 1));
                    isDisableSelectDate = true;
                  });
                  Future.delayed(Duration(seconds: 4),(){
                    setState(() {
                      isDisableSelectDate = false;
                    });
                  });
                }),
              ]),
            ),
          Expanded(child: pages[tabIndex]),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: tabColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: tabIndex,
          onTap: (i) => setState(() => tabIndex = isDisableBottomNav? 3:i),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Daily Goals'),
            BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Intake Graph'),
            BottomNavigationBarItem(icon: Icon(Icons.input), label: 'Daily Intake'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

MaterialColor createMaterialColor(Color c) {
  final strengths = <double>[.05] + List.generate(9, (i) => 0.1 * (i + 1));
  final swatch = <int, Color>{};
  final r = c.r, g = c.g, b = c.b;
  for (var s in strengths) {
    final ds = 0.5 - s;
    swatch[(s * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : 255 - r) * ds).round() as int,
      g + ((ds < 0 ? g : 255 - g) * ds).round() as int,
      (b + ((ds < 0 ? b : 255 - b) * ds).round()) as int,
      1,
    );
  }
  return MaterialColor(c.value, swatch);
}
