import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TherapyAppBar extends ConsumerWidget {
  TherapyAppBar({Key? key,} ) : super(key: key);

  static const double kMyAppbarHeight = 44.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: kMyAppbarHeight,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.fromLTRB(20, 0, 20, 8),
        title: Text(
          'Terapie',
          style: TextStyle(
              color:  Theme.of(context).appBarTheme.foregroundColor,
              fontSize: Theme.of(context).appBarTheme.titleTextStyle?.fontSize ?? 24,
              fontWeight: FontWeight.w400
          ),
        ),
      ),
    );
  }
}
