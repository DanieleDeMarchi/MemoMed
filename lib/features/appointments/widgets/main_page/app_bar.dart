import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AppointmentsAppBar extends ConsumerWidget {
  const AppointmentsAppBar({Key? key}) : super(key: key);

  static const double kMyAppbarHeight = 44.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      pinned: true,
      collapsedHeight: kMyAppbarHeight,
      toolbarHeight: kMyAppbarHeight,
      expandedHeight: kMyAppbarHeight,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.only(bottom:10),
        title:
        Align(
          alignment: const Alignment(0, 2),
          child: Text(
            'Visite',
            style: TextStyle(
                color:  Theme.of(context).appBarTheme.foregroundColor,
                fontSize: Theme.of(context).appBarTheme.titleTextStyle?.fontSize ?? 24,
                fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }
}
