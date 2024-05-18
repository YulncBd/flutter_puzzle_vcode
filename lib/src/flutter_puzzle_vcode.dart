// @description:
// @date :2024/5/16
// @author by zanghuidong

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_vcode/src/puzzle_vcode_clipper.dart';
import 'package:flutter_puzzle_vcode/src/puzzle_vcode_slider.dart';
import 'package:flutter_puzzle_vcode/src/puzzle_vcode_util.dart';

class FlutterPuzzleVCode extends StatefulWidget {
  const FlutterPuzzleVCode({super.key});

  @override
  State<StatefulWidget> createState() => _FlutterPuzzleVCodeState();
}

class _FlutterPuzzleVCodeState extends State<FlutterPuzzleVCode>
    with TickerProviderStateMixin {
  late Widget imageWidget;
  bool imageRender = false;
  ByteData? imgBytes;
  ui.Image? bgImage;
  PuzzleClipper? clipper;
  Widget? puzzleBgWidget;
  Widget? puzzleWidget;

  late AnimationController successAnimationController;
  late Animation successAnimation;
  late AnimationController failAnimationController;
  late Animation failAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PuzzleVCodeUtil.canvasWidth = MediaQuery.of(context).size.width - 70;
      PuzzleVCodeUtil.renderSuccess = true;
      setState(() {});
    }); // 在下一帧回调中获取宽度

    successAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PuzzleVCodeUtil.verifyResult = 0;
            successAnimationController.reverse();
          });
        }
      });
    successAnimation =
        Tween(begin: -24.0, end: 0.0).animate(successAnimationController);
    failAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            failAnimationController.reverse();
            PuzzleVCodeUtil.verifyResult = 0;
            initData();
          });
        }
      });
    failAnimation =
        Tween(begin: -24.0, end: 0.0).animate(failAnimationController);

    initData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    successAnimationController.dispose();
    failAnimationController.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    PuzzleVCodeUtil.resetData();
    clipper = PuzzleClipper(
        pinX: PuzzleVCodeUtil.offsetX,
        pinY: PuzzleVCodeUtil.offsetY,
        pinW: PuzzleVCodeUtil.puzzleW,
        radius: PuzzleVCodeUtil.puzzleRadius);
    imgBytes = await PuzzleVCodeUtil.canvasImage(
        PuzzleVCodeUtil.canvasWidth, PuzzleVCodeUtil.canvasHeight);
    if (imgBytes != null) {
      ui.Codec codec =
          await ui.instantiateImageCodec(imgBytes!.buffer.asUint8List());
      ui.FrameInfo frame = await codec.getNextFrame();
      bgImage = frame.image;
    }
    if (bgImage != null && clipper != null) {
      puzzleBgWidget = PuzzleVCodeUtil.puzzleBgWidget(bgImage!, clipper!);
    }
    if (imgBytes != null && clipper != null) {
      puzzleWidget = PuzzleVCodeUtil.puzzleWidget(imgBytes!, clipper!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(15),
        // alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: _buildContentWidget(),
      ),
    );
  }

  Widget _buildContentWidget() {
    if (PuzzleVCodeUtil.renderSuccess) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: PuzzleVCodeUtil.canvasHeight,
                ),
                if (puzzleBgWidget != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      width: PuzzleVCodeUtil.canvasWidth,
                      height: PuzzleVCodeUtil.canvasHeight,
                      child: puzzleBgWidget,
                    ),
                  ),
                if (puzzleWidget != null)
                  Transform.translate(
                    offset: Offset(
                        -PuzzleVCodeUtil.offsetX +
                            (PuzzleVCodeUtil.canvasWidth -
                                    PuzzleVCodeUtil.puzzleW -
                                    PuzzleVCodeUtil.puzzleRadius) *
                                PuzzleVCodeUtil.sliderValue,
                        0),
                    child: puzzleWidget,
                  ),
                if (PuzzleVCodeUtil.verifyResult == 2)
                  AnimatedBuilder(
                    animation: failAnimation,
                    builder: (BuildContext context, Widget? child) {
                      return Positioned(
                        bottom: failAnimation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          color: const Color(0xffce594b),
                          height: 24,
                          child: const Text(
                            '验证失败，请重试',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                if (PuzzleVCodeUtil.verifyResult == 1)
                  AnimatedBuilder(
                    animation: successAnimation,
                    builder: (BuildContext context, Widget? child) {
                      return Positioned(
                        bottom: successAnimation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          color: const Color(0xff83ce3f),
                          height: 24,
                          child: const Text(
                            '验证通过',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PuzzleVCodeSlider(
            onChanged: (value) {
              setState(() {
                PuzzleVCodeUtil.sliderValue = value;
              });
            },
            onChangeEnd: (value) {
              double dif = (PuzzleVCodeUtil.canvasWidth -
                          PuzzleVCodeUtil.puzzleW -
                          PuzzleVCodeUtil.puzzleRadius) *
                      value -
                  PuzzleVCodeUtil.offsetX;
              if (dif.abs() < 10) {
                PuzzleVCodeUtil.verifyResult = 1;
                setState(() {});
                successAnimationController.forward();
              } else {
                PuzzleVCodeUtil.verifyResult = 2;
                setState(() {});
                failAnimationController.forward();
              }
            },
          ),
        ],
      );
    } else {
      return Container(
        alignment: Alignment.center,
        height: PuzzleVCodeUtil.canvasHeight +
            10 +
            PuzzleVCodeUtil.puzzleW +
            PuzzleVCodeUtil.puzzleRadius,
        child: const CupertinoActivityIndicator(
          color: Colors.grey,
        ),
      );
    }
  }
}
