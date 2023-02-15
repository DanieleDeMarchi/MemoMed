import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memo_med/features/appointments/widgets/listview_tile.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../model/appointment.dart';

class AppontmentSliverList extends ConsumerWidget {
  final List<Appointment> appointments;
  final String dateFormat;
  final String locale;
  final IconData? subtitleIcon;

  const AppontmentSliverList(this.appointments, this.dateFormat, this.locale, {Key? key, this.subtitleIcon}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SlidableAutoCloseBehavior(
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => TimelineTile(
            isFirst: index == 0,
            isLast: index == appointments.length - 1,
            indicatorStyle: IndicatorStyle(
              width: 40,
              color: Colors.green,
              indicatorXY: 0.35,
              indicator: Container(
                  color: Colors.white,
                  child: Icon(
                    // FontAwesomeIcons.circleXmark,
                    appointments[index].isCompleted() ? Icons.check_circle : Icons.circle_outlined,
                    color: appointments[index].isCompleted() ? Colors.teal.shade700 : Colors.grey,
                  )),
              padding: const EdgeInsets.all(2),
            ),
            alignment: TimelineAlign.manual,
            lineXY: 0.05,
            beforeLineStyle: const LineStyle(thickness: 2),
            afterLineStyle: const LineStyle(thickness: 2),
            endChild: SizedBox(
              height: 110,
              child: AppointmentTimelineTile(appointments[index], dateFormat, locale, subtitleIcon: subtitleIcon,),
            ),
          ),
          childCount: appointments.length,
        ),
      ),
    );
  }
}


