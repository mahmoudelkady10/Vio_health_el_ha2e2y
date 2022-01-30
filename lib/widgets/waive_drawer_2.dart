import 'package:flutter/material.dart';
import 'package:medic_app/model/wave_data.dart';

class WaveformPainter2 extends CustomPainter {
  final WaveformData data;
  final int startingFrame;
  final int endFrame;
  final double zoomLevel;
  Paint? painter;
  final Color color;
  final double strokeWidth;


  WaveformPainter2(this.data,
      {this.strokeWidth = 1.0, this.startingFrame = 0, this.zoomLevel = 1, this.color = Colors.blue, required this.endFrame}) {
    painter = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data == null) {
      return;
    }

    final path = data.path2(size, fromFrame: startingFrame, zoomLevel: zoomLevel, endFrame: endFrame);
    canvas.drawPath(path, painter!);
  }

  @override
  bool shouldRepaint(WaveformPainter2 oldDelegate) {
    if (oldDelegate.data != data) {
      debugPrint("Redrawing");
      return true;
    }
    return false;
  }
}