import 'package:flutter/material.dart';
import 'package:igclone/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreenAnimation extends StatelessWidget {
  const LoadingScreenAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.discreteCircle(
      color: blueColor,
      size: 40,
      secondRingColor: Colors.pink,
      thirdRingColor: Colors.purple,
    );
  }
}

class ProgressAnimation extends StatelessWidget {
  const ProgressAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.prograssiveDots(
      color: Colors.white,
      size: 22,
    );
  }
}
