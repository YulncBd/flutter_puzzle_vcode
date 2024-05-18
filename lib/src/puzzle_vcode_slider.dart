// @description:
// @date :2024/5/17
// @author by irwin

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_puzzle_vcode/src/puzzle_vcode_util.dart';

class PuzzleVCodeSlider extends StatefulWidget {
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  const PuzzleVCodeSlider(
      {super.key, required this.onChanged, required this.onChangeEnd});

  @override
  State<StatefulWidget> createState() => _PuzzleVCodeSliderState();
}

class _PuzzleVCodeSliderState extends State<PuzzleVCodeSlider> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF1F8),
            borderRadius: BorderRadius.circular(3),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(240, 240, 240, 0.6),
                offset: Offset(0, 0),
                blurRadius: 8,
                blurStyle: BlurStyle.inner,
              )
            ],
          ),
        ),
        const Text(
          '拖动滑块完成拼图',
          style: TextStyle(
              fontSize: 14,
              color: Color(0xffb7bcd1),
              decoration: TextDecoration.none),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: PuzzleVCodeUtil.moveOffsetX,
          child: Container(
            color: const Color.fromRGBO(106, 160, 255, 0.8),
          ),
        ),
        Positioned(
          left: max(
              0,
              min(PuzzleVCodeUtil.moveOffsetX,
                  PuzzleVCodeUtil.canvasWidth - 50)),
          child: GestureDetector(
            onPanStart: (details) {
              PuzzleVCodeUtil.startOffsetX = details.localPosition.dx;
            },
            onPanUpdate: (DragUpdateDetails details) {
              PuzzleVCodeUtil.moveOffsetX = max(
                  0,
                  min(
                      details.localPosition.dx -
                          PuzzleVCodeUtil.startOffsetX +
                          PuzzleVCodeUtil.endOffsetX,
                      PuzzleVCodeUtil.canvasWidth - 50));
              setState(() {});
              widget.onChanged(PuzzleVCodeUtil.moveOffsetX /
                  (PuzzleVCodeUtil.canvasWidth - 50));
            },
            onPanEnd: (details) {
              PuzzleVCodeUtil.endOffsetX = PuzzleVCodeUtil.moveOffsetX;
              widget.onChangeEnd(PuzzleVCodeUtil.endOffsetX /
                  (PuzzleVCodeUtil.canvasWidth - 50));
            },
            child: Container(
              height: 44,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xffcccccc),
                    offset: Offset(0, 0),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 2,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xdd6aa0ff),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 24,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xdd6aa0ff),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xdd6aa0ff),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
