import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:memo_med/features/commons/widgets/detail_element.dart';

import '../../model/appointment.dart';

class InfoView extends StatelessWidget {
  final Appointment appointment;

  const InfoView({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    child: DetailElement(
                      text: appointment.user.nome,
                      label: "Membro della famiglia",
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      appointment.user.avatarImage,
                    ),
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: DetailElement(text: appointment.nome, label: "Titolo"),
            ),
            const Divider(
              thickness: 1,
              height: 25,
            ),
            if (appointment.luogo != null && appointment.luogo!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.houseMedical,
                      size: 22,
                      color: Colors.black54,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 22.0),
                        child: DetailElement(
                          text: appointment.luogo!,
                          label: "Luogo",
                          textFontSize: 18,
                          labelFontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (appointment.indirizzo != null && appointment.indirizzo!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 26,
                      color: Colors.black54,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: DetailElement(
                          text: appointment.indirizzo!,
                          label: "Indirizzo",
                          textFontSize: 18,
                          labelFontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (appointment.indirizzo != null && appointment.indirizzo!.isNotEmpty ||
                appointment.luogo != null && appointment.luogo!.isNotEmpty)
              const Divider(
                thickness: 1,
                height: 25,
              ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 18.0),
                    child: Icon(
                      Icons.calendar_today_outlined,
                      size: 26,
                      color: Colors.black54,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: DetailElement(
                      text: DateFormat('EEE, dd MMM y', 'it-IT').format(appointment.data),
                      label: "Data",
                      textFontSize: 18,
                      labelFontSize: 13,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: DetailElement(
                      text: DateFormat('HH:mm', 'it-IT').format(appointment.data),
                      label: "Ora",
                      textFontSize: 18,
                      labelFontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 18.0),
                    child: Icon(
                      Icons.notification_important_outlined,
                      size: 26,
                      color: Colors.black54,
                    ),
                  ),
                  DetailElement(
                    text: appointment.isNotifica
                        ? appointment.preavvisoNotifica.dropdownString
                        : "Non attiva",
                    label: "Notifica preavviso",
                    textFontSize: 18,
                    labelFontSize: 13,
                  ),
                ],
              ),
            ),
            if (appointment.note != null && appointment.note!.isNotEmpty)
              const Divider(
                thickness: 1,
                height: 30,
              ),
            if (appointment.note != null && appointment.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: DetailElement(
                  text: appointment.note!,
                  label: "Note aggiuntive",
                  maxLines: 20,
                  textFontSize: 18,
                  labelFontSize: 13,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
