import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';

class RoundedTabBar extends StatelessWidget {
  const RoundedTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: const Alignment(0, 1.1),
            child: Container(
              height: 26.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
          child: Material(
            elevation: 4.0,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            child: SegmentedTabControl(
              tabTextColor: Theme.of(context).primaryColorDark,
              selectedTabTextColor: Colors.white,
              height: 36,
              tabs: const [
                SegmentTab(
                  label: "Dettagli",
                ),
                SegmentTab(
                  label: "Diario assunzioni",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
