import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:memo_med/features/therapy/model/assunzione_farmaco.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../provider/assunzione_farmaco_provider.dart';

class DiarioAssunzioni extends ConsumerWidget {

  const DiarioAssunzioni({Key? key}) : super(key: key);

  setComplete(AssunzioneFarmaco assunzioneFarmaco, bool completed, WidgetRef ref) {
    ref.read(assunzioniFarmacoProvider.notifier).setCompleted(assunzioneFarmaco, completed);
  }

  Widget buildTile(BuildContext context, AssunzioneFarmaco assunzione, int index, bool isFirst,
      bool isLast, WidgetRef ref) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 25,
        color: Colors.green,
        indicatorXY: 0.5,
        indicator: Container(
            color: Colors.white,
            child: Icon(
              assunzione.completed ? Icons.check_circle : Icons.circle_outlined,
              color: assunzione.completed ? Colors.teal.shade700 : Colors.grey,
            )),
        padding: const EdgeInsets.all(1),
      ),
      alignment: TimelineAlign.manual,
      lineXY: 0.15,
      beforeLineStyle: const LineStyle(thickness: 1),
      afterLineStyle: const LineStyle(thickness: 1),
      endChild: Column(
        children: [
          Slidable(
            startActionPane: ActionPane(
              dismissible: DismissiblePane(
                  dismissThreshold: 0.5,
                  dismissalDuration: const Duration(milliseconds: 200),
                  resizeDuration: const Duration(milliseconds: 200),
                  onDismissed: () {
                    setComplete(assunzione, !assunzione.completed, ref);
                  }),
              extentRatio: 0.5,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  autoClose: false,
                  onPressed: (context) {
                    Slidable.of(context)?.dismiss(
                      ResizeRequest(const Duration(milliseconds: 200), () {}),
                      duration: const Duration(milliseconds: 200),
                    ).then((value) => setComplete(assunzione, !assunzione.completed, ref));
                  },
                  backgroundColor: assunzione.completed ? Colors.orange : Colors.teal.shade700,
                  foregroundColor: assunzione.completed ? Colors.white : Colors.white,
                  icon: assunzione.completed ? Icons.dangerous_outlined : Icons.check,
                  label: assunzione.completed ? 'Da completare' : 'Completata',
                )
              ],
            ),
            key: UniqueKey(),
            child: SizedBox(
              height: 65,
              child: Center(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEE, d MMM y', 'it-IT').format(assunzione.dataAssunzione),
                          style: const TextStyle(color: Colors.black87, fontSize: 15),
                        ),
                        Text(
                          DateFormat('HH:mm', 'it-IT').format(assunzione.dataAssunzione),
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 0, indent: 20)
        ],
      ),
      startChild: Center(
        child: Text((index + 1).toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<AssunzioneFarmaco> list = ref.watch(assunzioniTherapyProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: list.length,
        (context, index) => index < list.length
            ? buildTile(context, list[index], index, index == 0, index == list.length - 1, ref)
            : const SizedBox(
                height: 0,
              ),
      ),
    );
  }
}
