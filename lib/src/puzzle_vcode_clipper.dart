// @description:
// @date :2024/5/17
// @author by irwin

// clip path
import 'package:flutter/cupertino.dart';

class PuzzleClipper extends CustomClipper<Path> {
  final double pinX;
  final double pinY;
  final double pinW;
  final double radius;

  const PuzzleClipper(
      {required this.pinX,
      required this.pinY,
      required this.pinW,
      required this.radius});

  @override
  getClip(Size size) {
    // TODO: implement getClip
    Path path = Path();
    var space = (pinW - radius * 2) / 2.0;

    path.moveTo(pinX, pinY + radius);
    path.lineTo(pinX + space, pinY + radius);
    path.arcToPoint(Offset(pinX + space + radius * 2, pinY + radius),
        radius: Radius.circular(radius));
    path.lineTo(pinX + pinW, pinY + radius);
    path.lineTo(pinX + pinW, pinY + space + radius);
    path.arcToPoint(Offset(pinX + pinW, pinY + space + radius + radius * 2),
        radius: Radius.circular(radius));
    path.lineTo(pinX + pinW, pinY + pinW + radius);
    path.lineTo(pinX, pinY + pinW + radius);
    path.lineTo(pinX, pinY + space + radius + radius * 2);
    path.arcToPoint(Offset(pinX, pinY + radius + space),
        radius: Radius.circular(radius), clockwise: false);
    path.lineTo(pinX, pinY + radius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
