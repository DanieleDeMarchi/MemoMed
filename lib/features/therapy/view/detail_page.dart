import 'package:flutter/material.dart';
import 'package:memo_med/features/therapy/model/terapia.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/therapy/provider/provider.dart';

import '../widgets/detail_page/detail_sliver_app_bar.dart';
import '../widgets/detail_page/info_view.dart';
import '../widgets/detail_page/diario_assunzioni.dart';
import 'edit_therapy_page.dart';

class TherapyDetailPage extends ConsumerWidget {
  const TherapyDetailPage({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const TherapyDetailPage());
  }

  updateTherapy(BuildContext context, Terapia therapy) {
    final futureResult = Navigator.of(context).push(EditTherapyPage.route(therapy: therapy));
    futureResult.then((result) {
      if(result != null){

      }
    });
  }

  deleteTherapy(BuildContext context, Terapia therapy) {
    showDialog(context: context, builder: (context) => DeleteTherapyAlertDialog(therapy));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Terapia therapy= ref.watch(currentTherapyProvider)!;
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Theme.of(context).primaryColorDark,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: DetailSliverAppBar(
                therapy: therapy,
                onUpdate: () => updateTherapy(context, therapy),
                onDelete: () => deleteTherapy(context, therapy),
              ),
            ),
          ],
          body: Container(
            color: Colors.white,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        SliverToBoxAdapter(
                          child: TherapyInfoView(therapy: therapy),
                        )
                      ],
                    );
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        const DiarioAssunzioni()
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteTherapyAlertDialog extends ConsumerWidget {
  final Terapia therapy;

  const DeleteTherapyAlertDialog(
    this.therapy, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("Conferma eliminazione"),
      content: const Text('Sei sicuro di voler eliminare questa terapia?'),
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
              String therapyName = therapy.nomeTerapia != null && therapy.nomeTerapia!.isEmpty
                  ? therapy.nomeTerapia!
                  : therapy.farmaco;
              await ref.read(therapyProvider.notifier).remove(therapy);
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Terapia $therapyName rimosso")));
            },
            child: const Text(
              'Elimina',
              style: (TextStyle(color: Colors.red)),
            ))
      ],
    );
  }
}
