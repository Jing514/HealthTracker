import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/common/widget.dart';
import 'package:project/graph_folder/widget/graph_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project/common/function.dart';


final dbRef = FirebaseDatabase.instance.ref();

class GraphScreen extends StatefulWidget {
  final DateTime date;
  const GraphScreen({super.key, required this.date});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}


class _GraphScreenState extends State<GraphScreen> {
  String? intakeId;
  String? weightId;
  String? userId;
  String age = "";
  String height = "";
  String gender = "";
  double requirementC = 0.0;
  List<double> percentages = [];
  List<String> xLabels = [];
  bool flag = true;

  String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    init();

  }
  @override
  void didUpdateWidget(covariant GraphScreen old) {
    super.didUpdateWidget(old);
    if (_dayKey(old.date) != _dayKey(widget.date)) {
      init();
    }
  }

  Future<void> init()async{
    percentages.clear();
    xLabels.clear();
    setState(() {
      flag = true;
    });

    intakeId = null;
    weightId = null;
    await _loadProfile();
    await _load7daysData(); //not working

    setState(() {
      flag = false;
    });

    // print(requirementC);
    // print(int.parse(_calController.text));
  }

  Future<void> _load7daysData() async{
    for (int i = 6; i >= 0; i--){
      DateTime d = widget.date.subtract(Duration(days: i));
      String key = DateFormat('yyyy-MM-dd').format(d);
      await _loadWeightId(d);
      String w = await _loadWeight();
      await _loadIntakeId(d);
      String c = await _loadIntake();

      requirementC = calculateCalorieRequirement(gender, w, height, age);
      double pct = (requirementC > 0 && double.parse(w).toInt() != 0)
          ? (double.parse(c) / requirementC) * 100
          : 0;
      percentages.add(pct);
      xLabels.add("${d.month}/${d.day}");
    }
  }

  // intake check(date) and push
  Future<void> _loadIntakeId(DateTime date) async {
    final u = await dbRef.child('intake').orderByChild('date').equalTo(_dayKey(date)).get();
    if(u.value == null){
      final k = dbRef.child('intake').push().key;
      if (k == null) return;
      intakeId = k;
      await dbRef.child('intake/$intakeId').update({'calorie': "0", 'water': "0", 'date': _dayKey(date),});
      return;
    }
    final data = u.value as Map<dynamic,dynamic>;
    intakeId = data.keys.first;
  }


  //weight check (date) and push
  Future<void> _loadWeightId(DateTime date) async {
    final u = await dbRef.child('weight').orderByChild('date').equalTo(_dayKey(date)).get();
    if(u.value == null){
      final k = dbRef.child('weight').push().key;
      if (k == null) return;
      weightId = k;
      await dbRef.child('weight/$weightId').update({'weight': "0", 'date': _dayKey(date),});
      return;
    }
    final data = u.value as Map<dynamic,dynamic>;
    weightId = data.keys.first;
  }

  //load intake
  Future<String> _loadIntake() async {
    final snap = await dbRef.child('intake/$intakeId').get();
    if (snap.value == null){
      return "";
    }

    final data = snap.value as Map<dynamic, dynamic>;

    return data["calorie"];
  }

  //load weight
  Future<String> _loadWeight() async {
    final snap = await dbRef.child('weight/$weightId').get();
    if (snap.value == null){
      return "";
    }
    final data = snap.value as Map<dynamic, dynamic>;
    return data["weight"];

  }

  //load profile from users
  Future<void> _loadProfile() async {
    if (userId != null){
      return;
    }
    final u = await dbRef.child('users').get();
    if(u.value == null){
      return;
    }
    final data = u.value as Map<dynamic,dynamic>;
    userId = data.keys.first;

    if (userId == null){
      return;
    }
    final loadUser = await dbRef.child('users/$userId').get();
    final user = loadUser.value as Map<dynamic,dynamic>;
    setState(() {
      age = user["age"];
      gender = user["gender"];
      height = user["height"];
    });
  }


  @override
  Widget build(BuildContext context) {

    // showing the percentages of the last 7 days
    return flag?
    Center(child: CircularProgressIndicator())
        :Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              "Intake completion graph",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(child: SizedBox()),
        // graph size and/or border
        Expanded(
          child: Center(
            child: Container(
              width: 300,
              height: 300,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.grey),
              //   color: Colors.white,
              // ),
              child: LineGraph(
                percentages: percentages,
                xLabels: xLabels,
                fixedMax: 150,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
