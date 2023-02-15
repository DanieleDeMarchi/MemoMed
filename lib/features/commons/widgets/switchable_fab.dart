import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:memo_med/assets/my_icons_icons.dart';
import 'package:memo_med/features/appointments/view/edit_appointment_page.dart';
import 'package:memo_med/features/therapy/view/edit_therapy_page.dart';
import 'package:uuid/uuid.dart';

class SwitchableFab extends StatelessWidget {
  const SwitchableFab(this.currentIndex, {Key? key}) : super(key: key);

  final int currentIndex;

  Widget? buildFAB(BuildContext context, int index) {
    switch (index) {
      case 0:
        return SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.edit_calendar_rounded),
              label: "Visita medica",
              onTap: () => Navigator.push(context, EditAppointmentForm.route()),
            ),
            SpeedDialChild(
              child: const Icon(MyIcons.add_pill),
              label: "Terapia",
              onTap: () => Navigator.push(context, EditTherapyPage.route()),
            ),
          ],
        );
      case 1:
        return FloatingActionButton(
          heroTag: Uuid().v4(),
          key: UniqueKey(),
          child: const Icon(Icons.edit_calendar_rounded),
          onPressed: () => Navigator.push(context, EditAppointmentForm.route()),
        );
      case 2:
        return FloatingActionButton(
          heroTag: Uuid().v4(),
          key: UniqueKey(),
          child: const Icon(MyIcons.add_pill),
          onPressed: () => Navigator.push(context, EditTherapyPage.route()),
        );
      case 3:
        return const SizedBox.shrink();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: buildFAB(context, currentIndex),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        });
  }
}
