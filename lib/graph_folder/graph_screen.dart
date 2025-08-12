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
}