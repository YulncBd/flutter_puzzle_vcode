// @description:
// @date :2024/5/16
// @author by irwin

import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_vcode/src/puzzle_vcode_bg_canvas.dart';
import 'dart:ui' as ui;
import 'package:flutter_puzzle_vcode/src/puzzle_vcode_canvas.dart';
import 'package:flutter_puzzle_vcode/src/puzzle_vcode_clipper.dart';

class PuzzleVCodeUtil {

  static bool renderSuccess = false; //
  static int verifyResult = 0; // 1 成功 2失败
  static double canvasWidth = 300;
  static double canvasHeight = 200;

  static double offsetX = 0;
  static double offsetY = 0;
  static double puzzleW = 44.0;
  static double puzzleRadius = 8.0;

  static double startOffsetX = 0;
  static double endOffsetX = 0;
  static  double moveOffsetX = 0;
  static  double sliderValue = 0.0;

  static void resetData() {
    offsetX = PuzzleVCodeUtil.getRandomDouble(90, canvasWidth - 90);
    offsetY = PuzzleVCodeUtil.getRandomDouble(40, canvasHeight - 90);

    startOffsetX = 0;
    moveOffsetX = 0;
    endOffsetX = 0;
    sliderValue = 0;
    verifyResult = 0;
  }

  static Color randomColor() {
    return Color.fromRGBO(getRandomInt(100, 255), getRandomInt(100, 255),
        getRandomInt(100, 255), 1);
  }

  static int getRandomInt(int min, int max) {
    return Random().nextInt(max - min) + min;
  }

  static double getRandomDouble(double min, double max) {
    return Random().nextDouble() * (max - min) + min;
  }

  // 绘制背景图像
  static Future<ByteData> canvasImage(double width, double height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromPoints(const Offset(0.0, 0.0), Offset(width, height)));
    final Paint paint = Paint()..color = PuzzleVCodeUtil.randomColor();
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height), paint);
    // 随机10个图形
    for (int i = 0; i < 10; i++) {
      paint.color = PuzzleVCodeUtil.randomColor();
      canvas.save();
      double randomValue = PuzzleVCodeUtil.getRandomDouble(0, 2);
      // 矩形
      if (randomValue > 1) {
        Rect rect = Rect.fromLTWH(
            PuzzleVCodeUtil.getRandomDouble(-20, width - 20),
            PuzzleVCodeUtil.getRandomDouble(-20, height - 20),
            PuzzleVCodeUtil.getRandomDouble(10, width / 2 + 10),
            PuzzleVCodeUtil.getRandomDouble(10, height / 2 + 10));
        canvas.rotate((PuzzleVCodeUtil.getRandomDouble(-90, 90) * pi) / 180);
        canvas.drawRect(rect, paint);
        canvas.restore();
      } else {
        // 圆形
        double ran = PuzzleVCodeUtil.getRandomDouble(-pi, pi);
        Rect rect = Rect.fromCircle(
            center: Offset(PuzzleVCodeUtil.getRandomDouble(0, width),
                PuzzleVCodeUtil.getRandomDouble(0, height)),
            radius: PuzzleVCodeUtil.getRandomDouble(10, height / 2.0 + 10));
        canvas.drawArc(rect, ran, ran + pi * 1.5, true, paint);
        canvas.restore();
      }
    }
    final picture = recorder.endRecording();
    ui.Image img = await picture.toImage(width.toInt(), height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!;
  }

  static Widget puzzleBgWidget(ui.Image bgImage, PuzzleClipper clipper) {
    return PuzzleVCodeBgCanvas(
      bgImage: bgImage,
      clipper: clipper,
    );
  }

  static Widget puzzleWidget(ByteData imgBytes, PuzzleClipper clipper) {
    return PuzzleVCodeCanvas(
      imgBytes: imgBytes,
      clipper: clipper,
    );
  }
}
