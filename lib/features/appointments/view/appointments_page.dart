import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/appointments/widgets/main_page/app_bar.dart';
import 'package:memo_med/features/appointments/widgets/main_page/calendar.dart';
import 'package:memo_med/features/appointments/widgets/main_page/tab_bar.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:memo_med/features/commons/widgets/sliver_overlap_pinned.dart';
import '../widgets/listview_day.dart';
import '../widgets/listview_month.dart';
import '../widgets/listview_week.dart';

class AppointmentsPage extends ConsumerWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => AppointmentsPage());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: MultiSliver(
                children: const [
                  AppointmentsAppBar(),
                  AppointmentsCalendar(),
                  AppointmentsTabBar(),
                ],
              ),
            ),
          ];
        },
        body: Builder(
          builder: (context) {
            return TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPinnedOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    const AppointmentsListView_Day(),
                  ],
                ),
                CustomScrollView(slivers: [
                  SliverPinnedOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  const AppointmentsListView_Week(),
                ]),
                CustomScrollView(slivers: [
                  SliverPinnedOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  const AppointmentsListView_Month(),
                ]),
              ],
            );
          },
        ),
      ),
    );
  }
}
