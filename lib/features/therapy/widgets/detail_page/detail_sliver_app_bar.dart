import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:memo_med/gen/assets.gen.dart';
import 'package:memo_med/features/commons/widgets/progress_bar.dart';

import '../../model/assunzione_farmaco.dart';
import '../../model/terapia.dart';
import '../../provider/assunzione_farmaco_provider.dart';
import './rounded_tab_bar.dart';
import 'contextual_menu.dart';


class DetailSliverAppBar extends StatelessWidget {
  final Terapia therapy;
  final Function onUpdate;
  final Function onDelete;

  const DetailSliverAppBar({Key? key, required this.therapy, required this.onUpdate, required this.onDelete}) : super(key: key);

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
      flexibleSpace: AppBabBody(therapy: therapy),
      bottom: const PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: SizedBox(height: 50, child: RoundedTabBar()),
      ),
    );
  }
}


class AppBabBody extends StatelessWidget {
  final Terapia therapy;
  const AppBabBody({Key? key, required this.therapy}) : super(key: key);

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
                right: 0,
                width: 300,
                child: Image.asset(
                  Assets.images.therapy.path,
                  fit: BoxFit.cover,
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, 0.5),
                    end: Alignment(0.0, -0.3),
                    colors: <Color>[
                      Color.fromRGBO(0, 0, 0, 0.6),
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
            padding: const EdgeInsets.only(bottom: 50),
            child: AppBarTitle(
              terapia: therapy,
            ),
          ),
        )
      ],
    );
  }
}

class AppBarTitle extends ConsumerWidget {
  final Terapia terapia;

  const AppBarTitle({Key? key, required this.terapia}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<AssunzioneFarmaco> list = ref.watch(assunzioniTherapyProvider);
    int totali = list.length;
    int completate = list.where((element) => element.completed).length;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
                child: Text(
                  terapia.farmaco,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "$completate assunzioni su $totali completate",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              ProgressBar(
                height: 8.0,
                progress: totali > 0 ? completate / totali : 0,
              )
            ],
          ),
        ),
      ],
    );
  }
}
