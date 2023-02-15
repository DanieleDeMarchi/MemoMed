import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/appointments/appointments.dart';
import 'package:memo_med/features/appointments/model/appointment.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'empty_page.dart';
import 'main_page/appontment_sliver_list.dart';
import 'main_page/pinned_header.dart';

class AppointmentsListView_Day extends ConsumerWidget {
  const AppointmentsListView_Day({super.key});

  Widget? getMorningAppointment(List<Appointment> appointments) {
    List<Appointment> app = appointments.where((e) => e.getDate().hour < 12).toList();
    if (app.isNotEmpty) {
      return MultiSliver(
        pushPinnedChildren: true,
        children: [
          const PinnedHeader(
            title: "Mattina",
          ),
          AppontmentSliverList(app, "HH:mm", "it-IT", subtitleIcon: Icons.access_time),
        ],
      );
    }
    return null;
  }

  Widget? getAfternoonAppointment(List<Appointment> appointments) {
    List<Appointment> app =
        appointments.where((e) => e.getDate().hour >= 12 && e.getDate().hour < 18).toList();
    if (app.isNotEmpty) {
      return MultiSliver(
        pushPinnedChildren: true,
        children: [
          const PinnedHeader(
            title: "Pomeriggio",
          ),
          AppontmentSliverList(app, "HH:mm", "it-IT", subtitleIcon: Icons.access_time),
        ],
      );
    }
    return null;
  }

  Widget? getEveningAppointment(List<Appointment> appointments) {
    List<Appointment> app = appointments.where((e) => e.getDate().hour >= 18).toList();
    if (app.isNotEmpty) {
      return MultiSliver(
        pushPinnedChildren: true,
        children: [
          const PinnedHeader(
            title: "Sera",
          ),
          AppontmentSliverList(app, "HH:mm", "it-IT", subtitleIcon: Icons.access_time),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Appointment> appointments = ref.watch(appointmentsDayProvider);

    if (appointments.isEmpty) {
      return const SliverFillRemaining(child: EmptyPage());
    }

    Widget? morning = getMorningAppointment(appointments);
    Widget? afternoon = getAfternoonAppointment(appointments);
    Widget? evening = getEveningAppointment(appointments);

    return MultiSliver(
      children: [
        if (morning != null) morning,
        if (afternoon != null) afternoon,
        if (evening != null) evening,
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 200,
          ),
        )
      ],
    );
  }
}


