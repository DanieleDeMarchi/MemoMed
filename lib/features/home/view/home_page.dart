import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:memo_med/features/commons/provider/date_provider.dart';
import 'package:memo_med/features/home/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        HomeAppBar(),
        SelectedFamilyMember(),
        TodayDateHeader(),
        HomeList(),
      ],
    );
  }
}

class TodayDateHeader extends ConsumerWidget {
  const TodayDateHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime currentDate = ref.watch(currentDateTimeProvider);

    return SliverAppBar(
      pinned: true,
      collapsedHeight: 80,
      backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
      scrolledUnderElevation: 4.0,
      flexibleSpace: Material(
        borderRadius:
            const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE', 'it-IT').format(currentDate),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                DateFormat('dd MMMM yyyy', 'it-IT').format(currentDate),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
