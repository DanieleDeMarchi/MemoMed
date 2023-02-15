import 'package:memo_med/features/commons/provider/date_provider.dart';
import 'package:memo_med/features/therapy/model/assunzione_farmaco.dart';
import 'package:memo_med/features/therapy/model/terapia.dart';
import 'package:memo_med/features/therapy/service/therapy_service.dart';
import 'package:memo_med/utils/date_utils.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tuple/tuple.dart';

import 'package:memo_med/features/family/provider/users_provider.dart';
import '../repository/therapy_repository.dart';
import 'assunzione_farmaco_provider.dart';

final initialListProvider = FutureProvider((ref) {
  ref.watch(usersProvider);
  return TherapyRepository().getAll();
});

final terapieInCorsoProvider = Provider<List<Terapia>>((ref) {
  DateTime currentDate = ref.watch(currentDateTimeProvider);
  List<AssunzioneFarmaco> assunzioniList = ref.watch(assunzioniFarmacoProvider);
  List<Terapia> inCorso = ref
      .watch(therapyProvider)
      .where((t) => !isAfterDay(t.dataInizio, currentDate))
      .where((t) => assunzioniList.where((a) => a.idTerapia == t.id && !a.completed).isNotEmpty)
      .toList()
    ..sort((a, b) => a.dataInizio.compareTo(b.dataInizio));
  return inCorso;
});

final terapieCompletateProvider = Provider<List<Terapia>>((ref) {
  List<AssunzioneFarmaco> assunzioniList = ref.watch(assunzioniFarmacoProvider);
  List<Terapia> terapie = ref.watch(therapyProvider);
  return terapie
      .where((t) => assunzioniList.where((a) => a.idTerapia == t.id && !a.completed).isEmpty)
      .toList()
    ..sort((a, b) => b.dataInizio.compareTo(a.dataInizio));
});

final terapieFutureProvider = Provider<List<Terapia>>((ref) {
  DateTime currentDate = ref.watch(currentDateTimeProvider);
  List<AssunzioneFarmaco> assunzioniList = ref.watch(assunzioniFarmacoProvider);
  return ref
      .watch(therapyProvider)
      .where((terapia) => isAfterDay(terapia.dataInizio, currentDate))
      .where((t) => assunzioniList.where((a) => a.idTerapia == t.id && !a.completed).isNotEmpty)
      .toList()
    ..sort((a, b) => a.dataInizio.compareTo(b.dataInizio));
});

final therapyProvider = StateNotifierProvider<TherapyNotifier, List<Terapia>>((ref) {
  final list = ref.watch(initialListProvider);
  return TherapyNotifier(list.value);
});

class TherapyNotifier extends StateNotifier<List<Terapia>> {
  late final TherapyService therapyManager;

  TherapyNotifier([List<Terapia>? terapie]) : super(terapie ?? []) {
    therapyManager = TherapyService();
  }

  Future<Terapia> add(Terapia terapia) async {
    Terapia added = await therapyManager.insertOne(terapia);
    state = [...state, added];
    return added;
  }

  Future<void> remove(Terapia terapia) async {
    await therapyManager.remove(terapia);
    state = [
      for (final t in state)
        if (t.id != terapia.id!) t,
    ];
  }

  Future<Terapia> edit(Terapia t) async {
    Terapia updated = await therapyManager.edit(t);
    state = [
      for (final terapia in state)
        if (terapia.id != updated.id) terapia else updated,
    ];

    return updated;
  }
}

final assunzioniTerapiaCounterProvider = Provider.family<Tuple2<int, int>, int>((ref, therapyId) {
  Iterable<AssunzioneFarmaco> list =
      ref.watch(assunzioniFarmacoProvider).where((as) => as.idTerapia == therapyId);
  if (list.isEmpty) {
    return const Tuple2(0, 0);
  }
  return Tuple2(list.where((e) => e.completed).length, list.length);
});
