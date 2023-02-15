import 'package:flutter/material.dart';

class PinnedHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;

  const PinnedHeader({Key? key, required this.title, this.subtitle, this.titleStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      scrolledUnderElevation: 3,
      toolbarHeight: subtitle != null ? 60 : 45,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: titleStyle ?? const TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(120, 120, 120, 1.0),
                fontWeight: FontWeight.w800,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty)
              Text(
                subtitle!,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}