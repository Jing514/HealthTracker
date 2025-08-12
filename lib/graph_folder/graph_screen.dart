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
}

//
// class GraphScreen extends StatelessWidget {
//   final Map<String, DayData> dailyData;
//   final DateTime selectedDate;
//   final String age = "";
//   final String height = "";
//   final String gender = "";
//