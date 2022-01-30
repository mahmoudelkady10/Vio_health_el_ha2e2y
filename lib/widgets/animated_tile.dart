import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../constant.dart';

class AnimatedTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          'Offered Services',
          textStyle: kLabelTextStyle,
          textAlign: TextAlign.center,
          speed: const Duration(milliseconds: 200),
        ),
      ],
      totalRepeatCount: 4,
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}