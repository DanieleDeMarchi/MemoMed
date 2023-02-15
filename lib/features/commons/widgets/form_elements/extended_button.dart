import 'package:flutter/material.dart';

class ExtendedButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;

  const ExtendedButton({required this.child, required this.onPressed, Key? key}) : super(key: key);

  final double borderRadius = 20;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(5),
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(45)),
        alignment: Alignment.center,
        backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
