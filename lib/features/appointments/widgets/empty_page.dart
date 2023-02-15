import 'package:flutter/material.dart';

import 'package:memo_med/gen/assets.gen.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 300,
          child: Image(
            image: Assets.images.appointmentsEmpty.provider(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Text(
            "Nessuna visita da visualizzare per il giorno selezionato",
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}