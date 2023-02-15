import 'package:flutter/material.dart';

class RoundedTabAppBar extends StatelessWidget {
  const RoundedTabAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: const Alignment(0.0, 1.1),
              child: Container(
                height: 26.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Material(
                elevation: 4.0,
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(25),
                child: const SizedBox(
                  height: 36,
                  width: 200,
                  child: Center(
                    child: Text(
                      "Dettagli",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}