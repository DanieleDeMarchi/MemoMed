import 'package:memo_med/features/commons/activity.dart';
import 'package:memo_med/features/appointments/appointments.dart';
import 'package:memo_med/features/appointments/model/appointment.dart';
import 'package:memo_med/features/family/provider/provider.dart';
import 'package:memo_med/features/home/model/terapia_assunzione.dart';
import 'package:memo_med/features/home/model/user_activity.dart';
import 'package:memo_med/features/family/model/user.dart';
import 'package:memo_med/features/therapy/model/assunzione_farmaco.dart';
import 'package:memo_med/features/therapy/provider/assunzione_farmaco_provider.dart';
import 'package:memo_med/main.dart';

import 'package:riverpod/riverpod.dart';

import 'package:memo_med/features/commons/provider/date_provider.dart';
import 'package:memo_med/utils/date_utils.dart';

import '../../therapy/model/terapia.dart';
import '../../therapy/provider/therapy_provider.dart';

final todayActivitiesProvider = Provider<Map<User, UserWithActivities>>((ref) {
  List<User> users = ref.watch(usersProvider);
  List<Appointment> appointments = ref.watch(appointmentsProvider);
  List<TerapiaAssunzione> terapiaAssunzioni = ref.watch(terapiaAssunzioniProvider);
  DateTime currentDay = ref.watch(currentDateTimeProvider);

  Map<User, UserWithActivities> userActivityMap = {for (var e in users) e: UserWithActivities(e)};

  appointments.where((element) => isSameDay(element.getDate(), currentDay))
      .forEach((element) => userActivityMap[element.user]?.appendActivity(element));

  terapiaAssunzioni.where((element) => isSameDay(element.getDate(), currentDay))
      .forEach((element) => userActivityMap[element.terapia.user]?.appendActivity(element));

  return userActivityMap;
});

final familyCountProvider = Provider<int>((ref) {
  Map<User, UserWithActivities> all = ref.watch(todayActivitiesProvider);
  return all.values.map((e) => e.getCount()).fold(0, (value, element) => value + element);
});

final familyCompletedCountProvider = Provider<int>((ref) {
  Map<User, UserWithActivities> all = ref.watch(todayActivitiesProvider);
  return all.values.map((e) => e.getCompletedCount()).fold(0, (value, element) => value + element);
});

final selectedUserProvider = StateProvider<UserWithActivities?>((ref) => null);

final activityListProvider = Provider<List<Activity>>((ref) {
  UserWithActivities? selectedUser = ref.watch(selectedUserProvider);
  Iterable<UserWithActivities> allUsersWithActivities = ref.watch(todayActivitiesProvider).values;

  if (selectedUser != null || allUsersWithActivities.where((e) => e == selectedUser).isNotEmpty) {
    return selectedUser!.activities.toList()..sort((a, b) => a.getDate().compareTo(b.getDate()));
  }

  return allUsersWithActivities.expand((e) => e.activities).toList()
    ..sort((a, b) => a.getDate().compareTo(b.getDate()));
});

final toCompleteActivitiesCount = Provider<int>((ref) {
  Iterable<UserWithActivities> allUsersWithActivities = ref.watch(todayActivitiesProvider).values;

  DateTime currentDate = ref.watch(currentDateTimeProvider);

  return allUsersWithActivities
      .expand((e) => e.activities)
      .where((e) => e.getDate().isBefore(currentDate) && !e.isCompleted())
      .length;
});

final terapiaAssunzioniProvider = Provider<List<TerapiaAssunzione>>((ref) {
  Map<int, Terapia> terapie = {for (var t in ref.watch(therapyProvider)) t.id!: t};
  List<AssunzioneFarmaco> assunzioni = ref.watch(assunzioniFarmacoProvider)..sort((a, b) => a.dataAssunzione.compareTo(b.dataAssunzione));
  List<TerapiaAssunzione> toReturn = [];

  Map<int, List<TerapiaAssunzione>> assunzioniMap= {for (var t in terapie.keys) t: []};

  assunzioni.forEach((a) {
    if(assunzioniMap.containsKey(a.idTerapia)){
      int index= assunzioniMap[a.idTerapia]!.length;
      assunzioniMap[a.idTerapia]!.add(TerapiaAssunzione(terapie[a.idTerapia]!, a, index));
    }
  });


  for (var list in assunzioniMap.values) {
    toReturn.addAll(list);
  }

  return toReturn;
});
