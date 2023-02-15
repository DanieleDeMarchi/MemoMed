import 'package:flutter/material.dart';
import 'package:memo_med/features/therapy/model/terapia.dart';
import 'package:memo_med/features/therapy/widgets/form_page/edit_therapy_form.dart';

class EditTherapyPage extends StatelessWidget {
  final Terapia? therapy;

  const EditTherapyPage({Key? key, this.therapy}) : super(key: key);

  static Route<dynamic> route({Terapia? therapy}) {
    return MaterialPageRoute<dynamic>(builder: (_) => EditTherapyPage(therapy: therapy,));
  }

  @override
  Widget build(BuildContext context) {
    ScrollController sc= ScrollController();
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: false,
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColorDark,
      body: NestedScrollView(
        controller: sc,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          SliverAppBar.medium(
            title: Text(therapy == null ? 'Nuova Terapia' : 'Modifica Terapia',
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).primaryColorDark,
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(color: Colors.white),
            elevation: 4,
          )
        ],
        body: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Theme.of(context).backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TherapyForm(therapy: therapy),
          ),
        ),
      ),
    );
  }
}
