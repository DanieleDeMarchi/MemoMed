import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:memo_med/features/commons/widgets/detail_element.dart';
import '../../model/terapia.dart';

class TherapyInfoView extends StatelessWidget {
  final Terapia therapy;

  const TherapyInfoView({Key? key, required this.therapy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Expanded(
                    child: DetailElement(
                      text: therapy.user.nome,
                      label: "Membro della famiglia",
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      therapy.user.avatarImage,
                    ),
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: DetailElement(text: therapy.farmaco, label: "Farmaco"),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: DetailElement(
                        text: therapy.assunzioni.toString(),
                        label: "Assunzioni",
                        textFontSize: 18,
                        labelFontSize: 13,
                      ),
                    ),
                  ),
                  if (therapy.assunzioni > 1 && therapy.frequenzaAssunzione != null)
                    Flexible(
                      flex: 3,
                      child: DetailElement(
                        text: therapy.frequenzaAssunzione!.dropdownString,
                        label: "Frequenza",
                        textFontSize: 18,
                        labelFontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  const Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: EdgeInsets.only(right: 18.0),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        size: 26,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: DetailElement(
                      text: DateFormat('dd MMM, HH:mm', 'it-IT').format(therapy.dataInizio),
                      label: "Data inizio",
                      textFontSize: 18,
                      labelFontSize: 13,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: DetailElement(
                      text: DateFormat('dd MMM', 'it-IT').format(therapy.dataFine),
                      label: "Data fine",
                      textFontSize: 18,
                      labelFontSize: 14,
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
                    text: therapy.isNotifica
                        ? therapy.preavvisoNotifica?.dropdownString ?? ""
                        : "Non attiva",
                    label: "Notifica preavviso",
                    textFontSize: 18,
                    labelFontSize: 13,
                  ),
                ],
              ),
            ),
            if (therapy.note != null && therapy.note!.isNotEmpty)
              const Divider(
                thickness: 1,
                height: 30,
              ),
            if (therapy.note != null && therapy.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: DetailElement(
                  text: therapy.note!,
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
