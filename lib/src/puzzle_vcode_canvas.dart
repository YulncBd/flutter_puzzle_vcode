// @description:
// @date :2024/5/16
// @author by irwin

import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_vcode/src/puzzle_vcode_clipper.dart';

class PuzzleVCodeCanvas extends StatefulWidget {
  final ByteData imgBytes;
  final PuzzleClipper clipper;

  const PuzzleVCodeCanvas(
      {super.key, required this.imgBytes, required this.clipper});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PuzzleVCodeCanvasState();
  }
}

class _PuzzleVCodeCanvasState extends State<PuzzleVCodeCanvas> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
      child: CustomPaint(
        painter: PuzzleCanvasPainter(clipper: widget.clipper),
        child: ClipPath(
          clipper: widget.clipper,
          child: Image.memory(Uint8List.view(widget.imgBytes.buffer)),
        ),
      ),
    );
  }
}

// canvas shadow
class PuzzleCanvasPainter extends CustomPainter {
  final CustomClipper<Path> clipper;

  PuzzleCanvasPainter({required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Shadow shadow =
        const Shadow(color: Colors.black, offset: Offset(0, 0), blurRadius: 5);
    Paint paint = shadow.toPaint();
    var path = clipper.getClip(size).shift(const Offset(0, 0));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
