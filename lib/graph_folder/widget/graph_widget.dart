import 'dart:math';
import 'package:flutter/material.dart';

class LineGraph extends StatelessWidget {
  final List<double> percentages;
  final List<String> xLabels;
  final double fixedMax;

  const LineGraph({
    Key? key,
    required this.percentages,
    required this.xLabels,
    required this.fixedMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: _LineGraphPainter(
        percentages: percentages,
        xLabels: xLabels,
        fixedMax: fixedMax,
      ),
    );
  }
}

class _LineGraphPainter extends CustomPainter {
  final List<double> percentages;
  final List<String> xLabels;
  final double fixedMax;

  _LineGraphPainter({
    required this.percentages,
    required this.xLabels,
    required this.fixedMax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftMargin = 50.0;
    final bottomMargin = 40.0;
    final axisPaint = Paint()..color = Colors.black..strokeWidth = 1.0;

    // the y axis
    canvas.drawLine(
      Offset(leftMargin, 0),
      Offset(leftMargin, size.height - bottomMargin),
      axisPaint,
    );
    // x axis
    canvas.drawLine(
      Offset(leftMargin, size.height - bottomMargin),
      Offset(size.width, size.height - bottomMargin),
      axisPaint,
    );

    // 50%, 100%, 150% grid lines
    final yTicks = [50.0, 100.0, 150.0];
    for (double tick in yTicks) {
      final y = (size.height - bottomMargin) -
          ((tick / fixedMax) * (size.height - bottomMargin - 10));
      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(size.width, y),
        Paint()..color = Colors.grey..strokeWidth = 0.5,
      );
      // y-axis labelling
      final span = TextSpan(
        text: "${tick.toInt()}%",
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(leftMargin - tp.width - 5, y - tp.height / 2));
    }

    // rotate y axis label
    final yLabelSpan = TextSpan(
      text: "percentage of caloric intake",
      style: TextStyle(color: Colors.black, fontSize: 10),
    );
    final yLabelPainter = TextPainter(
      text: yLabelSpan,
      textDirection: TextDirection.ltr,
    );
    yLabelPainter.layout();
    canvas.save();
    canvas.translate(
      10,
      (size.height - bottomMargin) / 2 + yLabelPainter.width / 2,
    );
    canvas.rotate(-pi / 2);
    yLabelPainter.paint(canvas, Offset(0, 0));
    canvas.restore();

    final paintLine = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final paintDot = Paint()..color = Colors.red;

    if (percentages.isEmpty) return;
    final spacing = (size.width - leftMargin - 20) / (percentages.length - 1);
    final path = Path();
    for (int i = 0; i < percentages.length; i++) {
      final x = leftMargin + i * spacing;
      final y = (size.height - bottomMargin) -
          ((percentages[i] / fixedMax) * (size.height - bottomMargin - 10));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 4.0, paintDot);

      // x axis label
      final span = TextSpan(
        text: xLabels[i],
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      final tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(x - tp.width / 2, size.height - bottomMargin + 5),
      );
    }
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
