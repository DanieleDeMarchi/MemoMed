import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressAvatar extends StatelessWidget {
  const ProgressAvatar(
      {Key? key,
        required this.innerAvatarRadius,
        required this.externalAvatarRadius,
        required this.progressIndicatorWidth,
        required this.titleFontSize,
        required this.subtitleFontSize,
        required this.avatarImage,
        required this.title,
        required this.subTitle,
        required this.progress,
        this.progressColor,
        this.progressBackground,
        this.titleColor,
        this.subtitleColor})
      : super(key: key);

  const ProgressAvatar.large(
      {Key? key,
        this.innerAvatarRadius = 30.0,
        this.externalAvatarRadius = 35.0,
        this.progressIndicatorWidth = 3.0,
        this.titleFontSize = 20.0,
        this.subtitleFontSize = 14.0,
        required this.avatarImage,
        required this.title,
        required this.subTitle,
        required this.progress,
        this.progressColor,
        this.progressBackground,
        this.titleColor,
        this.subtitleColor})
      : super(key: key);

  const ProgressAvatar.small(
      {Key? key,
        this.innerAvatarRadius = 18.0,
        this.externalAvatarRadius = 23.0,
        this.progressIndicatorWidth = 2.5,
        this.titleFontSize = 16.0,
        this.subtitleFontSize = 14.0,
        required this.avatarImage,
        required this.title,
        required this.subTitle,
        required this.progress,
        this.progressColor,
        this.progressBackground,
        this.titleColor,
        this.subtitleColor})
      : super(key: key);

  final double innerAvatarRadius;
  final double externalAvatarRadius;
  final double progressIndicatorWidth;
  final double titleFontSize;
  final double subtitleFontSize;
  final double progress;
  final String avatarImage;
  final String title;
  final String subTitle;
  final Color? progressColor;
  final Color? progressBackground;
  final Color? titleColor;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CircularPercentIndicator(
          radius: externalAvatarRadius,
          lineWidth: progressIndicatorWidth,
          animation: true,
          percent: progress,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: progressBackground ?? Colors.white70,
          progressColor: progressColor ?? Theme.of(context).primaryColorDark,
          center: CircleAvatar(
            backgroundColor: Colors.white70,
            radius: innerAvatarRadius,
            backgroundImage: AssetImage(avatarImage),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 140
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: titleColor ?? Colors.black,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                Text(
                  subTitle,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: subtitleColor ?? Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
