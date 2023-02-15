import 'package:flutter/material.dart';

import 'package:memo_med/features/commons/widgets/widgets.dart';
import 'package:memo_med/features/appointments/model/appointment.dart';
import '../widgets/form_page/edit_appointment_form.dart';

class EditAppointmentForm extends StatelessWidget {
  final Appointment? appointment;

  const EditAppointmentForm({Key? key, this.appointment}) : super(key: key);

  static Route<dynamic> route({Appointment? appointment}) {
    return MaterialPageRoute<dynamic>(
        builder: (_) => EditAppointmentForm(appointment: appointment));
  }

  @override
  Widget build(BuildContext context) {
    bool isNew = appointment == null;
    return AutoUnfocus(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).primaryColorDark,
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
              SliverAppBar.medium(
                title: Text(isNew ? 'Nuova visita' : 'Modifica visita',
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: Theme.of(context).primaryColorDark,
                foregroundColor: Colors.white,
                titleTextStyle: const TextStyle(color: Colors.white),
                elevation: 4,
              )
            ],
            body: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    color: Theme.of(context).backgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 4.0),
                  child: AppointmentsForm(appointment: appointment),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
