import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final double? height;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const ProgressBar({Key? key, required this.progress, this.height, this.foregroundColor, this.backgroundColor,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Center(
            child: LinearProgressIndicator(
              minHeight: (height ?? 6.0) + 1.0,
              backgroundColor: backgroundColor,
              value: 0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Center(
              child: LinearProgressIndicator(
                minHeight: height ?? 6.0,
                color: foregroundColor,
                backgroundColor: backgroundColor,
                value: progress,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
