import 'package:flutter/material.dart';

import 'package:memo_med/gen/assets.gen.dart';

class EmptyPage extends StatelessWidget {
  final String message;
  const EmptyPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          child: Image(
            image: Assets.images.therapyEmpty.provider(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}