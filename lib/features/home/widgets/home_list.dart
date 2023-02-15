import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:memo_med/features/commons/provider/date_provider.dart';
import 'package:memo_med/features/appointments/model/appointment.dart';
import 'package:memo_med/features/home/model/terapia_assunzione.dart';
import 'package:memo_med/features/therapy/view/detail_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:memo_med/features/commons/activity.dart';
import 'package:memo_med/gen/assets.gen.dart';
import 'package:memo_med/features/appointments/provider/appointments_provider.dart';
import 'package:memo_med/features/appointments/view/detail_page.dart';
import 'package:memo_med/features/therapy/provider/assunzione_farmaco_provider.dart';
import '../provider/home_provider.dart';

class HomeList extends ConsumerWidget {
  const HomeList({super.key});

  Widget buildTile(
      BuildContext context, Activity activity, bool isFirst, bool isLast, WidgetRef ref) {
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
              // FontAwesomeIcons.circleXmark,
              activity.isCompleted() ? Icons.check_circle : Icons.circle_outlined,
              color: activity.isCompleted() ? Colors.teal.shade700 : Colors.grey,
            )),
        padding: const EdgeInsets.all(2),
      ),
      alignment: TimelineAlign.manual,
      lineXY: 0.15,
      beforeLineStyle: const LineStyle(thickness: 2),
      afterLineStyle: const LineStyle(thickness: 2),
      endChild: Column(
        children: [HomeListTile(activity), const Divider(height: 0, indent: 0, thickness: 1,)],
      ),
      startChild: Center(
        child: Text(DateFormat('HH:mm', 'it-IT').format(activity.getDate())),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Activity> activities = ref.watch(activityListProvider);

    if (activities.isEmpty) {
      return const SliverFillRemaining(child: EmptyWidget());
    }

    return SlidableAutoCloseBehavior(
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index != activities.length - 1) {
              return buildTile(
                  context, activities[index], index == 0, index == activities.length - 1, ref);
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: buildTile(
                    context, activities[index], index == 0, index == activities.length - 1, ref),
              );
            }
          },
          childCount: activities.length,
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          child: Image(
            image: Assets.images.homeEmpty.provider(),
          ),
        ),
        const Text(
          "Nessuna attività da svolgere oggi.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              children: [
                TextSpan(text: 'Premi sul pulsante '),
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(
                      FontAwesomeIcons.circlePlus,
                      color: Colors.teal,
                      size: 20,
                    ),
                  ),
                ),
                TextSpan(text: ' per aggiungere una terapia o una visita medica.'),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

class HomeListTile extends ConsumerWidget {
  final Activity activity;

  const HomeListTile(
    this.activity, {
    Key? key,
  }) : super(key: key);

  void setComplete(Activity item, bool completed, WidgetRef ref) {
    if (item is Appointment) {
      ref.read(appointmentsProvider.notifier).setCompleted(item, completed);
    } else if (item is TerapiaAssunzione) {
      ref.read(assunzioniFarmacoProvider.notifier).setCompleted(item.assunzioneFarmaco, completed);
    }
  }

  Widget getActivityTile(Activity item) {
    if (item is Appointment) {
      return AppointmentTile(appointment: item);
    } else if (item is TerapiaAssunzione) {
      return AssunzioneMedicinaleTile(terapiaAssunzione: item);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      startActionPane: ActionPane(
        dismissible: DismissiblePane(
            dismissThreshold: 0.5,
            dismissalDuration: const Duration(milliseconds: 200),
            resizeDuration: const Duration(milliseconds: 200),
            onDismissed: () {
              setComplete(activity, !activity.isCompleted(), ref);
            }),
        extentRatio: 0.5,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            autoClose: false,
            onPressed: (context) {
              Slidable.of(context)
                  ?.dismiss(
                    ResizeRequest(const Duration(milliseconds: 200), () {}),
                    duration: const Duration(milliseconds: 200),
                  )
                  .then((value) => setComplete(activity, !activity.isCompleted(), ref));
            },
            backgroundColor: activity.isCompleted() ? Colors.orange : Colors.teal.shade700,
            foregroundColor: activity.isCompleted() ? Colors.white : Colors.white,
            icon: activity.isCompleted() ? Icons.dangerous_outlined : Icons.check,
            label: activity.isCompleted() ? 'Da completare' : 'Completata',
          )
        ],
      ),
      key: UniqueKey(),
      child: getActivityTile(activity),
    );
  }
}

class AppointmentTile extends ConsumerWidget {
  final Appointment appointment;

  const AppointmentTile({Key? key, required this.appointment}) : super(key: key);

  void onTap(BuildContext context) {
    Navigator.of(context).push(AppointmentDetailPage.route(appointment));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool showSwipeTip = false;

    if (!appointment.isCompleted()) {
      DateTime currentDateTime = ref.watch(currentDateTimeProvider);
      showSwipeTip = currentDateTime.isAfter(appointment.getDate());
    }
    return InkWell(
      onTap: () => onTap(context),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple, borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: Icon(
                                FontAwesomeIcons.houseMedical,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                          Text(
                            "Visita",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      appointment.nome,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20),
                      maxLines: 1,
                    ),
                  ),
                  if((appointment.luogo != null && appointment.luogo!.isNotEmpty) ||
                      (appointment.indirizzo != null && appointment.indirizzo!.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Text(
                      (){
                        if(appointment.luogo != null && appointment.luogo!.isNotEmpty){
                          return appointment.luogo;
                        }
                        if(appointment.indirizzo != null && appointment.indirizzo!.isNotEmpty){
                          return appointment.indirizzo;
                        }
                        return "";
                      }()!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                      maxLines: 1,
                    ),
                  ),
                  if(showSwipeTip) Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Shimmer.fromColors(
                        baseColor: Colors.black54,
                        highlightColor: Colors.black26,
                        child: showSwipeTip
                            ? const Text('Swipe per segnare come copletato')
                            : const Text('')),
                  )
                ],
              ),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(appointment.user.avatarImage),
            ),
          ],
        ),
      ),
    );
  }
}

class AssunzioneMedicinaleTile extends ConsumerWidget {
  final TerapiaAssunzione terapiaAssunzione;

  const AssunzioneMedicinaleTile({Key? key, required this.terapiaAssunzione}) : super(key: key);

  void onTap(BuildContext context, WidgetRef ref) {
    ref.read(currentTherapyProvider.notifier).state = terapiaAssunzione.terapia;
    Future<dynamic> result = Navigator.of(context).push(TherapyDetailPage.route());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool showSwipeTip = false;

    if (!terapiaAssunzione.isCompleted()) {
      DateTime currentDateTime = ref.watch(currentDateTimeProvider);
      showSwipeTip = currentDateTime.isAfter(terapiaAssunzione.getDate());
    }
    return InkWell(
      onTap: () => onTap(context, ref),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlue, borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              FontAwesomeIcons.pills,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          Text(
                            "Terapia",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      terapiaAssunzione.terapia.farmaco,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20),
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: Text(
                      "Assunzione ${terapiaAssunzione.index + 1} di ${terapiaAssunzione.terapia.assunzioni}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                      maxLines: 1,
                    ),
                  ),
                  if(showSwipeTip) Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Shimmer.fromColors(
                        baseColor: Colors.black54,
                        highlightColor: Colors.black26,
                        child: showSwipeTip
                            ? const Text('Swipe per segnare come copletato')
                            : const Text('')),
                  )
                ],
              ),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(terapiaAssunzione.user.avatarImage),
            ),
          ],
        ),
      ),
    );
  }
}
