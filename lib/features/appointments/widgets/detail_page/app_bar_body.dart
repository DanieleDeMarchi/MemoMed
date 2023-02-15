import 'package:flutter/material.dart';
import 'package:memo_med/features/appointments/model/appointment.dart';

import '../../../../gen/assets.gen.dart';

class AppBarBody extends StatelessWidget {
  final Appointment appointment;
  const AppBarBody({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 30,
                right: -30,
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: Assets.images.visitaMedica.provider(),
                  fit: BoxFit.cover,
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, 0.5),
                    end: Alignment.center,
                    colors: <Color>[
                      Color.fromRGBO(0, 0, 0, 0.4),
                      Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Padding(
            padding: const EdgeInsets.only(bottom: 55),
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.nome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    appointment.completed ? "Attività completata" : "Attività da completare",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
