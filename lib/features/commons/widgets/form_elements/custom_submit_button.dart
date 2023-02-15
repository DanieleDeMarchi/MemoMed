import 'dart:ui';
import 'package:flutter/material.dart';
import 'extended_button.dart';

class SubmitButton extends StatelessWidget {
  final Function callbackFunction;
  final String text;
  const SubmitButton({Key? key, required this.callbackFunction, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
      child: ExtendedButton(
        onPressed: () => callbackFunction(),
        child: Text(text, style: const TextStyle(fontSize: 18),),
      ),
    );
  }
}