import 'package:flutter/material.dart';
import 'package:project/common/widget.dart';
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
                //save data here
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
                //save data here
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Weight saved!'))
                );
                requirementC = calculateCalorieRequirement(gender, _weightController.text, height, age);
                setState(() {

                });
              },
              child: const Text('Confirm')),
          const SizedBox(height: 12),

          // percentage circles (calories and water)
          //https://pub.dev/packages/percentages_with_animation

        ],
      );
  }
}


/// profile long confirm button line
/// load profile fake details
/// profile have data - open button bar
/// water widget - circle