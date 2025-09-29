import 'package:flutter/material.dart';
import 'package:project/intake_folder/widget/intake_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project/common/function.dart';

final dbRef = FirebaseDatabase.instance.ref();

class IntakeScreen extends StatefulWidget {
  final DateTime date;
  const IntakeScreen({super.key, required this.date});

  @override
  State<IntakeScreen> createState() => _IntakeScreenState();
}


class _IntakeScreenState extends State<IntakeScreen> {
  String? intakeId;
  String? weightId;
  String? userId;
  String age = "";
  String height = "";
  String gender = "";
  double requirementC = 0.0;
  double requirementW = 0.0;


  final _waterController = TextEditingController();
  final _calController = TextEditingController();
  final _weightController = TextEditingController();

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
  void didUpdateWidget(covariant IntakeScreen old) {
    super.didUpdateWidget(old);
    if (_dayKey(old.date) != _dayKey(widget.date)) {
      init();
      setState(() {

      });
    }
  }
  Future<void> init()async{
    intakeId = null;
    weightId = null;
    _waterController.text = "";
    _calController.text = "";
    _weightController.text = "";
    await _loadIntakeId();
    await _loadIntake();
    await _loadWeightId();
    await _loadWeight();
    await _loadProfile();

    requirementC = calculateCalorieRequirement(gender, _weightController.text, height, age);
    // print(requirementC.toString());
    // print(int.parse(_calController.text));
    requirementW = calculateWaterRequirement(_weightController.text);
  }
  // intake check(date) and push
  Future<void> _loadIntakeId() async {
    if (intakeId != null){
      return;
    }
    final u = await dbRef.child('intake').orderByChild('date').equalTo(_dayKey(widget.date)).get();
    if(u.value == null){
      final k = dbRef.child('intake').push().key;
      if (k == null) return;
      intakeId = k;
      await dbRef.child('intake/$intakeId').update({'calorie': "0", 'water': "0", 'date': _dayKey(widget.date),});
      return;
    }
    final data = u.value as Map<dynamic,dynamic>;
    intakeId = data.keys.first;
  }

  Future<void> _saveIntake() async {
    if (intakeId == null) {
      final k = dbRef.child('intake').push().key;
      if (k == null) return;
      intakeId = k;
    }
    print(intakeId);
    await dbRef.child('intake/$intakeId').update({'calorie': _calController.text, 'water': _waterController.text, 'date': _dayKey(widget.date),});
  }

  //weight check (date) and push
  Future<void> _loadWeightId() async {
    if (weightId != null){
      return;
    }
    final u = await dbRef.child('weight').orderByChild('date').equalTo(_dayKey(widget.date)).get();
    if(u.value == null){
      final k = dbRef.child('weight').push().key;
      if (k == null) return;
      weightId = k;
      await dbRef.child('weight/$weightId').update({'weight': "0", 'date': _dayKey(widget.date),});
      return;
    }
    final data = u.value as Map<dynamic,dynamic>;
    weightId = data.keys.first;
  }

  Future<void> _saveWeight() async {
    if (weightId == null) {
      final k = dbRef.child('weight').push().key;
      if (k == null) return;
      weightId = k;
    }
    print(weightId);
    await dbRef.child('weight/$weightId').update({'weight': _weightController.text, 'date': _dayKey(widget.date),});
  }

  //load intake
  Future<void> _loadIntake() async {
    final snap = await dbRef.child('intake/$intakeId').get();
    if (snap.value == null){
      return;
    }

    final data = snap.value as Map<dynamic, dynamic>;

    setState(() {
      _waterController.text = data["water"];
      _calController.text = data["calorie"];
    });
  }

  //load weight
  Future<void> _loadWeight() async {
    final snap = await dbRef.child('weight/$weightId').get();
    if (snap.value == null){
      return;
    }

    final data = snap.value as Map<dynamic, dynamic>;

    setState(() {
      _weightController.text = data["weight"];
    });
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
    int cal;
    double water;
    try{
      cal = double.parse(_calController.text).toInt();
      water = double.parse(_waterController.text);
    }catch(e){
      cal = 0;
      water = 0.0;
    }

    return
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _waterController,
              decoration: const InputDecoration(
                labelText: 'Enter daily water',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _calController,
              decoration: const InputDecoration(
                labelText: 'Enter daily calories',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 8),

          ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await _saveIntake();
                if(!context.mounted)return;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Intake saved!'))
                );
                setState(() {

                });
              },

              child: const Text('Confirm')),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Enter daily weight',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 8),

          ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await _saveWeight();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Weight saved!'))
                );
                requirementC = calculateCalorieRequirement(gender, _weightController.text, height, age);
                setState(() {

                });
              },
              child: const Text('Confirm')),
          const SizedBox(height: 12),


          const Text(
          'Daily Calorie Requirement:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
          requirementC.toInt().toString(),
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
          ),
          // percentage circles (calories and water)
          //https://pub.dev/packages/percentages_with_animation

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Row(
              children: [
                // Calorie circle
                Expanded(
                  child: Column(
                    children: [
                      Text("Calorie completion"),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CalorieCircle(
                          intake: cal, //this
re                          target: requirementC>0?requirementC:100000,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Water circle
                Expanded(
                  child: Column(
                    children: [
                      Text("Water completion"),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: WaterBar(
                          currentIntake: water, //this
                          goal: requirementW > 0? requirementW:2625,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ],
      );
  }
}


/// water widget - circle
