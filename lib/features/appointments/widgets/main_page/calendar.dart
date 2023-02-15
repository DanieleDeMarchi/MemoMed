import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:memo_med/features/commons/widgets/widgets.dart';
import 'package:memo_med/features/appointments/appointments.dart';

class AppointmentsCalendar extends ConsumerWidget {
  const AppointmentsCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<DateTime> appointmentsDates= ref.watch(appointmentsProvider).map((e) => e.getDate()).toList();
    return SliverToBoxAdapter(
      child: Material(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Calendar(
          events: appointmentsDates,
          onChange: (date) => ref.read(selectedDateProvider.notifier).state= date!,
          color: Theme.of(context).primaryColorDark,
          markerColor: Theme.of(context).primaryColorLight,
          weekFormat: true,
          weekStartsMonday: true,
          locale: "it",
        ),
      ),
    );
  }
}