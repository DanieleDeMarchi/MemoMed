import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'package:memo_med/features/commons/widgets/widgets.dart';

class AppointmentsTabBar extends StatelessWidget {
  const AppointmentsTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: kTextTabBarHeight,
        maxHeight: kTextTabBarHeight,
        child: Material(
          elevation: 1,
          shadowColor: Colors.black,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
          ),
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: const EdgeInsets.all(5),
              indicator: MaterialIndicator(
                color: Theme.of(context).primaryColorDark,
                topRightRadius: 5,
                topLeftRadius: 5,
                bottomRightRadius: 5,
                bottomLeftRadius: 5,
              ),
              splashBorderRadius: BorderRadius.circular(25),
              tabs: const [
                Tab(text: "Giorno"),
                Tab(text: "Settimana"),
                Tab(text: "Mese"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}