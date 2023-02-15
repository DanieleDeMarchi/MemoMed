import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:memo_med/features/appointments/appointments.dart';
import 'package:memo_med/features/appointments/model/appointment.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'empty_page.dart';
import 'main_page/appontment_sliver_list.dart';
import 'main_page/pinned_header.dart';

class AppointmentsListView_Month extends ConsumerWidget {
  const AppointmentsListView_Month({Key? key}) : super(key: key);

  String capitalize(String s){
    String firstLetter = s[0].toUpperCase();
    String capitalizedString = s.replaceFirst(s[0], firstLetter);
    return capitalizedString; // "Hello world"
  }

  List<Widget> getWidgetList(List<Appointment> appointments) {
    List<Widget> widgets = [];
    int daysInMont= DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
    Map<int, List<Appointment>> appPerDay = {
      for (var i = 1; i <= daysInMont; i++) i: appointments.where((e) => e.getDate().day == i).toList()
    };

    appPerDay.forEach(
          (day, appointments){
        if (appointments.isNotEmpty){
          widgets.add(
            MultiSliver(
              pushPinnedChildren: true,
              children: [
                PinnedHeader(
                  title: capitalize(DateFormat("EE, dd MMM yyyy", "it-IT").format(appointments.first.data)),
                  titleStyle: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(120, 120, 120, 1.0),
                    fontWeight: FontWeight.w600,
                  )
                ),
                AppontmentSliverList(appointments, "HH:mm", "it-IT", subtitleIcon: Icons.access_time),
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
    List<Appointment> appointments = ref.watch(appointmentsMonthProvider);

    if (appointments.isEmpty) {
      return const SliverToBoxAdapter(child: EmptyPage());
    }

    List<Widget> widgets = getWidgetList(appointments);
    return MultiSliver(children: widgets);
  }
}