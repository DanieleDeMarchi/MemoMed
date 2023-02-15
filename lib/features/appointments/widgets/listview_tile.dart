import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../model/appointment.dart';
import '../provider/appointments_provider.dart';
import '../view/detail_page.dart';

class AppointmentTimelineTile extends ConsumerWidget {
  final Appointment appointment;
  final String dateFormat;
  final String locale;
  final IconData? subtitleIcon;

  const AppointmentTimelineTile(this.appointment, this.dateFormat, this.locale,
      {Key? key, this.subtitleIcon})
      : super(key: key);

  void removeItem(BuildContext context, WidgetRef ref) {
    ref.read(appointmentsProvider.notifier).remove(appointment);
  }

  Future<bool> showConfirmDeleteAlert(BuildContext context) async {
    Future<bool?> result = showDialog<bool>(
        context: context, builder: (context) => DeleteAppointmentAlertDialog(appointment));
    return result.then((value) => value ?? false);
  }

  void delete(BuildContext context, WidgetRef ref) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(appointment.nome + ' rimossa'),
      ),
    );
    removeItem(context, ref);
  }

  void onDeleteActionTap(BuildContext context, WidgetRef ref) {
    showConfirmDeleteAlert(context).then((isDelete) {
      if (isDelete) {
        Slidable.of(context)?.dismiss(
          ResizeRequest(const Duration(milliseconds: 200), () {}),
          duration: const Duration(milliseconds: 200),
        );
        delete(context, ref);
      } else {
        Slidable.of(context)?.close();
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          dismissible: DismissiblePane(
            dismissalDuration: const Duration(milliseconds: 200),
            resizeDuration: const Duration(milliseconds: 200),
            confirmDismiss: () => showConfirmDeleteAlert(context),
            onDismissed: () => delete(context, ref),
            closeOnCancel: true,
          ),
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              autoClose: false,
              onPressed: (context) => onDeleteActionTap(context, ref),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Elimina',
            ),
          ],
        ),
        startActionPane: ActionPane(
          dismissible: DismissiblePane(
            dismissalDuration: const Duration(milliseconds: 200),
            resizeDuration: const Duration(milliseconds: 200),
            onDismissed: () => setComplete(appointment, !appointment.isCompleted(), ref),
            closeOnCancel: true,
          ),
          extentRatio: 0.45,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              autoClose: false,
              onPressed: (context) {
                Slidable.of(context)
                    ?.dismiss(
                      ResizeRequest(const Duration(milliseconds: 200), () {}),
                      duration: const Duration(milliseconds: 200),
                    )
                    .then((value) => setComplete(appointment, !appointment.isCompleted(), ref));
              },
              backgroundColor: appointment.isCompleted() ? Colors.orange : Colors.teal.shade700,
              foregroundColor: appointment.isCompleted() ? Colors.white : Colors.white,
              icon: appointment.isCompleted() ? Icons.dangerous_outlined : Icons.check,
              label: appointment.isCompleted() ? 'Da completare' : 'Completata',
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: AppointmentTile(
                appointment,
                dateFormat: dateFormat,
                locale: locale,
                subtitleIcon: subtitleIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  setComplete(Appointment appointment, bool completed, WidgetRef ref) {
    ref.read(appointmentsProvider.notifier).setCompleted(appointment, completed);
  }
}

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;
  final String dateFormat;
  final String locale;
  final IconData? subtitleIcon;

  const AppointmentTile(
    this.appointment, {
    Key? key,
    required this.dateFormat,
    required this.locale,
    this.subtitleIcon,
  }) : super(key: key);

  void onTap(BuildContext context) {
    Navigator.of(context).push(AppointmentDetailPage.route(appointment));
  }

  TextStyle _subtitleTextStyle(ThemeData theme) {
    final TextStyle textStyle =
        theme.useMaterial3 ? theme.textTheme.bodyMedium! : theme.textTheme.bodyText2!;
    final Color? color =
        theme.useMaterial3 ? theme.textTheme.bodySmall!.color : theme.textTheme.caption!.color;
    return textStyle.copyWith(color: color, fontSize: 13.0, overflow: TextOverflow.ellipsis);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListTile(
      onTap: () => onTap(context),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.nome,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(subtitleIcon ?? Icons.calendar_today_outlined, size: 15),
                          ),
                          Text(
                            DateFormat(dateFormat, locale).format(appointment.data),
                            style: _subtitleTextStyle(theme),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right)
            ],
          ),
          const Divider(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (appointment.luogo?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(
                      Icons.place,
                      size: 16,
                      color: theme.primaryColorDark,
                    ),
                  ),
                appointment.luogo?.isNotEmpty ?? false
                    ? Expanded(
                        child: Text((appointment.luogo ?? ""),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                _subtitleTextStyle(theme).copyWith(color: theme.primaryColorDark)),
                      )
                    : const Expanded(
                        child: SizedBox.shrink(),
                      ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.4
                  ),
                  child: Text(
                    appointment.user.nome,
                    style: _subtitleTextStyle(theme),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 4.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.black54,
                    child: CircleAvatar(
                      radius: 13.5,
                      backgroundImage: AssetImage(appointment.user.avatarImage),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteAppointmentAlertDialog extends StatelessWidget {
  final Appointment appointment;

  const DeleteAppointmentAlertDialog(
    this.appointment, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Conferma eliminazione"),
      content: const Text('Sei sicuro di voler eliminare questa terapia?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        // The "Yes" button
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Elimina',
            style: (TextStyle(color: Colors.red)),
          ),
        )
      ],
    );
  }
}
