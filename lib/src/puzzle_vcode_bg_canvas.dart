// @description:
// @date :2024/5/16
// @author by irwin

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_vcode/src/puzzle_vcode_clipper.dart';
import 'dart:ui' as ui;

class PuzzleVCodeBgCanvas extends StatefulWidget {
  final ui.Image bgImage;
  final PuzzleClipper clipper;

  const PuzzleVCodeBgCanvas(
      {super.key, required this.bgImage, required this.clipper});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PuzzleVCodeBgCanvasState();
  }
}

class _PuzzleVCodeBgCanvasState extends State<PuzzleVCodeBgCanvas> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
      child: CustomPaint(
        painter: PuzzleCanvasBgPainter(
            clipper: widget.clipper, bgImage: widget.bgImage),
      ),
    );
  }
}

// canvas shadow
class PuzzleCanvasBgPainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final ui.Image bgImage;

  PuzzleCanvasBgPainter({required this.clipper, required this.bgImage});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    canvas.drawImage(bgImage, const Offset(0, 0), paint);
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0x80000000);
    paint.style = PaintingStyle.fill;
    var path1 = clipper.getClip(size).shift(const Offset(0, 0));
    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
