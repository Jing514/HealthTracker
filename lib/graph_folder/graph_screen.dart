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

//
// class GraphScreen extends StatelessWidget {
//   final Map<String, DayData> dailyData;
//   final DateTime selectedDate;
//   final String age = "";
//   final String height = "";
//   final String gender = "";
//

  //////////////////////////////
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


    setState(() {
      flag = false;
    });

    // print(requirementC);
    // print(int.parse(_calController.text));
    @override
    Widget build(BuildContext context) {

      // calculating percentages of the last 7 days


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
