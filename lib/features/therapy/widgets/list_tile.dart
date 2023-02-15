import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:memo_med/features/commons/widgets/progress_bar.dart';
import 'package:memo_med/features/therapy/provider/provider.dart';
import 'package:memo_med/features/therapy/view/detail_page.dart';
import 'package:tuple/tuple.dart';

import '../model/terapia.dart';

class TherapyTile extends ConsumerWidget {
  final Terapia terapia;
  const TherapyTile(this.terapia, {Key? key}) : super(key: key);

  void removeItem(BuildContext context, WidgetRef ref) {
    ref.read(therapyProvider.notifier).remove(terapia);
  }

  void onTap(BuildContext context, WidgetRef ref) {
    ref.read(currentTherapyProvider.notifier).state = terapia;
    Navigator.of(context).push(TherapyDetailPage.route());
  }

  Future<bool> showConfirmDeleteAlert(BuildContext context) async {
    Future<bool?> result =
        showDialog<bool>(context: context, builder: (context) => DeleteTherapyAlertDialog(terapia));
    return result.then((value) => value ?? false);
  }

  void delete(BuildContext context, WidgetRef ref) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text((terapia.nomeTerapia != null && terapia.nomeTerapia!.isNotEmpty
                ? terapia.nomeTerapia!
                : terapia.farmaco) +
            ' rimossa'),
      ),
    );
    removeItem(context, ref);
  }

  void onDeleteActionTap(BuildContext context, WidgetRef ref) {
    showConfirmDeleteAlert(context).then((isDelete) {
      if (isDelete) {
        Slidable.of(context)
            ?.dismiss(
              ResizeRequest(const Duration(milliseconds: 200), () {}),
              duration: const Duration(milliseconds: 200),
            );
        delete(context, ref);
      } else {
        Slidable.of(context)?.close();
      }
    });
  }

  TextStyle _subtitleTextStyle(ThemeData theme) {
    final TextStyle textStyle =
        theme.useMaterial3 ? theme.textTheme.bodyMedium! : theme.textTheme.bodyText2!;
    final Color? color =
        theme.useMaterial3 ? theme.textTheme.bodySmall!.color : theme.textTheme.caption!.color;
    return textStyle.copyWith(color: color, fontSize: 13.0, overflow: TextOverflow.ellipsis);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData theme = Theme.of(context);

    Tuple2<int, int> tuple = ref.watch(assunzioniTerapiaCounterProvider(terapia.id!));
    int completate = tuple.item1;
    int totali = tuple.item2;

    return Card(
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          dismissible: DismissiblePane(
            dismissalDuration: const Duration(milliseconds: 200),
            resizeDuration: const Duration(milliseconds: 200),
            dismissThreshold: 0.5,
            closeOnCancel: true,
            confirmDismiss: () => showConfirmDeleteAlert(context),
            onDismissed: () => delete(context, ref),
          ),
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              autoClose: false,
              onPressed: (context) => onDeleteActionTap(context, ref),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Elimina',
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: ListTile(
                onTap: () => onTap(context, ref),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  terapia.nomeTerapia != null && terapia.nomeTerapia!.isNotEmpty
                                      ? terapia.nomeTerapia!
                                      : terapia.farmaco,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$completate assunzioni su $totali completate",
                                      style: _subtitleTextStyle(theme),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: ProgressBar(
                                        backgroundColor: Colors.black.withOpacity(0.04),
                                        progress: totali == 0 ? 0 : completate / totali,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                    const Divider(
                      height: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Icon(Icons.calendar_today_outlined, size: 15),
                          ),
                          Expanded(
                            child: Text(
                              DateFormat("dd MMM", 'it-IT').format(terapia.dataInizio) +
                                  " - " +
                                  DateFormat("dd MMM", 'it-IT').format(terapia.dataFine),
                              style: _subtitleTextStyle(theme),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.4
                            ),
                            child: Text(
                              terapia.user.nome,
                              style: _subtitleTextStyle(theme),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0, right: 4.0),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.black54,
                              child: CircleAvatar(
                                radius: 13.5,
                                backgroundImage: AssetImage(terapia.user.avatarImage),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //const Divider(height: 1, indent: 0),
          ],
        ),
      ),
    );
  }
}

class DeleteTherapyAlertDialog extends StatelessWidget {
  final Terapia therapy;

  const DeleteTherapyAlertDialog(
    this.therapy, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Conferma eliminazione"),
      content: const Text('Sei sicuro di voler eliminare questa terapia?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        // The "Yes" button
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Elimina',
            style: (TextStyle(color: Colors.red)),
          ),
        )
      ],
    );
  }
}
