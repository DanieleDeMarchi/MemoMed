import 'package:flutter/material.dart';
import 'package:memo_med/features/therapy/widgets/listview.dart';
import 'package:memo_med/features/therapy/widgets/tab_bar.dart';
import 'package:memo_med/features/therapy/widgets/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../provider/therapy_provider.dart';

class TherapyPage extends ConsumerWidget {
  const TherapyPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const TherapyPage());
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
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: MultiSliver(
                  children: [
                    TherapyAppBar(),
                    const TherapyTabBar(),
                  ],
                )),
          ];
        },
        body: Builder(
          builder: (context) {
            return TabBarView(
              children: [
                CustomScrollView(slivers: [
                    SliverOverlapInjector(
                      handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    TherapyListView(terapieCompletateProvider,
                        emptyMessage: "Nessuna terapia completata"),
                  ],
                ),
                CustomScrollView(slivers: [
                    SliverOverlapInjector(
                      handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    TherapyListView(terapieInCorsoProvider,
                    emptyMessage: "Nessuna terapia in corso"
                    ),
                  ],
                ),
                CustomScrollView(slivers: [
                    SliverOverlapInjector(
                      handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    TherapyListView(terapieFutureProvider,
                        emptyMessage: "Nessuna terapia futura"),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
