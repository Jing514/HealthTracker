import 'package:flutter/material.dart';

class CalorieCircle extends StatelessWidget {
  final int intake;
  final double target;
  const CalorieCircle({super.key, required this.intake, required this.target});
  @override


  Widget build(BuildContext context) {
    if (target <= 0) return const SizedBox.shrink();
    final pct = (intake / target).clamp(0.0, 1.0);
    final clr = Color.lerp(Colors.green, Colors.red, ((intake - target).abs() / target).clamp(0.0, 1.0))!;
    return Stack(alignment: Alignment.center, children: [
      CircularProgressIndicator(value: pct, strokeWidth: 40, valueColor: AlwaysStoppedAnimation<Color>(clr), backgroundColor: Colors.grey[300]),
      Text('${(pct * 100).toStringAsFixed(0)}%'),
    ]);
  }
}

class WaterBar extends StatelessWidget {
  final double currentIntake, goal;
  const WaterBar({super.key, required this.currentIntake, required this.goal});
  @override
  Widget build(BuildContext context) {
    if (goal <= 0) return const SizedBox.shrink();
    final pct = (currentIntake / goal).clamp(0.0, 1.0);
    final clr = Color.lerp(Colors.white, Colors.blue, pct)!;
    return Column(children: [
      LinearProgressIndicator(value: pct, minHeight: 10, valueColor: AlwaysStoppedAnimation<Color>(clr), backgroundColor: Colors.grey[300]),
      const SizedBox(height: 4),
      Text('${(pct * 100).toStringAsFixed(0)}%'),
    ]);
  }
}
