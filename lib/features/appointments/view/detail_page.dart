import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/appointments/appointments.dart';

import '../model/appointment.dart';
import '../widgets/detail_page/detail_sliver_app_bar.dart';
import '../widgets/detail_page/info_view.dart';
import './edit_appointment_page.dart';

class AppointmentDetailPage extends ConsumerStatefulWidget {
  final Appointment appointment;

  const AppointmentDetailPage({Key? key, required this.appointment}) : super(key: key);

  static Route<dynamic> route(Appointment appointment) {
    return MaterialPageRoute<dynamic>(
        builder: (_) => AppointmentDetailPage(appointment: appointment));
  }

  @override
  ConsumerState createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends ConsumerState<AppointmentDetailPage> {
  late Appointment appointment;

  updateAppointment(BuildContext context) async {
    final result =
    await Navigator.of(context).push(EditAppointmentForm.route(appointment: appointment));
    if (result != null) {
      Appointment updated = await result;
      setState(() {
        appointment = updated;
      });
    }
  }

  deleteAppointment(BuildContext context) {
    showDialog(context: context, builder: (context) => DeleteAppointmentAlertDialog(appointment));
  }

  @override
  void initState() {
    super.initState();
    appointment = widget.appointment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: DetailPageSliverAppBar(
              appointment: appointment,
              onUpdate: () => updateAppointment(context),
              onDelete: () => deleteAppointment(context),
            ),
          ),
        ],
        body: Container(
          color: Colors.white,
          child: Builder(
            builder: (BuildContext context) {
              return CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  SliverToBoxAdapter(
                    child: InfoView(appointment: appointment),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class DeleteAppointmentAlertDialog extends ConsumerWidget {
  final Appointment appointment;

  const DeleteAppointmentAlertDialog(
    this.appointment, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("Conferma eliminazione"),
      content: const Text('Sei sicuro di voler eliminare questo appuntamento?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        // The "Yes" button
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annulla')),
        TextButton(
            onPressed: () async {
              String appointmentName = appointment.nome;
              await ref.read(appointmentsProvider.notifier).remove(appointment);
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Appuntamento $appointmentName rimosso")));
            },
            child: const Text(
              'Elimina',
              style: (TextStyle(color: Colors.red)),
            ),
        )
      ],
    );
  }
}
