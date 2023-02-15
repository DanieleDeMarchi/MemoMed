import 'package:flutter/material.dart';
import 'package:memo_med/features/appointments/widgets/detail_page/rounded_tab_bar.dart';

import '../../model/appointment.dart';
import 'app_bar_body.dart';
import 'contextual_menu.dart';

class DetailPageSliverAppBar extends StatelessWidget {
  final Appointment appointment;
  final Function onUpdate;
  final Function onDelete;

  const DetailPageSliverAppBar({Key? key, required this.appointment, required this.onUpdate, required this.onDelete}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      backgroundColor: Theme.of(context).primaryColorDark,
      expandedHeight: MediaQuery.of(context).size.height * 0.45,
      foregroundColor: Colors.white,
      actions: <Widget>[
        ContextualMenu(
          onDelete: onDelete,
          onUpdate: onUpdate,
        )
      ],
      flexibleSpace: AppBarBody(appointment: appointment,),
      bottom: const PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: SizedBox(height: 50, child: RoundedTabAppBar()),
      ),
    );
  }
}
