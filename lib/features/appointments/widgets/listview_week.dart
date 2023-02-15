import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/appointments/appointments.dart';
import 'package:memo_med/features/appointments/model/appointment.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'main_page/appontment_sliver_list.dart';
import 'main_page/pinned_header.dart';
import 'empty_page.dart';


class AppointmentsListView_Week extends ConsumerWidget {
  const AppointmentsListView_Week({Key? key}) : super(key: key);

  List<Widget> getWidgetList(List<Appointment> appointments) {
    Map<int, List<Appointment>> appPerWeekDay = {
      for (var i = 1; i <= 7; i++) i: appointments.where((e) => e.getDate().weekday == i).toList()
    };

    List<Widget> widgets = [];
    const Map<int, String> weekdayName = {1: "Lunedì", 2: "Martedì", 3: "Mercoledì", 4: "Giovedì", 5: "Venerdì", 6: "Sabato", 7: "Domenica"};


    appPerWeekDay.forEach(
      (day, appointments){
        if (appointments.isNotEmpty){
          widgets.add(
            MultiSliver(
              pushPinnedChildren: true,
              children: [
                PinnedHeader(
                  title: weekdayName[day]!,
                ),
                AppontmentSliverList(appointments, "dd MMM, HH:mm", "it-IT"),
              ],
            ),
          );
        }
      },
    );

    widgets.add(const SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
      ),
    ));

    return widgets;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Appointment> appointments = ref.watch(appointmentsWeekProvider);
    if (appointments.isEmpty) {
      return const SliverToBoxAdapter(child: EmptyPage());
    }

    List<Widget> widgets = getWidgetList(appointments);
    return MultiSliver(children: widgets);
  }
}
