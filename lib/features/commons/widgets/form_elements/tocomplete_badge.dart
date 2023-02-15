import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:memo_med/features/home/provider/home_provider.dart';

class ToCompleteCountBadge extends ConsumerWidget {
  const ToCompleteCountBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int toComplete = ref.watch(toCompleteActivitiesCount);
    return toComplete == 0
        ? const Icon(FontAwesomeIcons.calendarCheck)
        : Badge(
            badgeContent: Text(
              toComplete.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            child: const Icon(FontAwesomeIcons.calendarCheck),
          );
  }
}
