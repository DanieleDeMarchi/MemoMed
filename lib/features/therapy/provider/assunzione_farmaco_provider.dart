import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/therapy/model/assunzione_farmaco.dart';
import 'package:memo_med/features/therapy/provider/provider.dart';
import 'package:memo_med/main.dart';

import '../model/terapia.dart';
import '../repository/assunzione_medicinali_reposirity.dart';
import '../service/assunzioni_service.dart';

final assunzioneFarmacoListProvider = FutureProvider<List<AssunzioneFarmaco>>((ref) async {
  return AssunzioniService().getAll();
});

final assunzioniFarmacoProvider =
    StateNotifierProvider<AssunzioniFarmacoNotifier, List<AssunzioneFarmaco>>((ref) {
  ref.watch(therapyProvider);
  var list = ref.watch(assunzioneFarmacoListProvider);
  return AssunzioniFarmacoNotifier(list.value);
});

class AssunzioniFarmacoNotifier extends StateNotifier<List<AssunzioneFarmaco>> {
  late final AssunzioniService _service;

  AssunzioniFarmacoNotifier([List<AssunzioneFarmaco>? initialList]) : super(initialList ?? []) {
    _service = AssunzioniService();
    fetchAll();
  }

  Future<void> fetchAll() async {
    _service.getAll().then((value) {
      if (mounted) {
        state = value;
      }
    });
  }

  Future<void> setCompleted(AssunzioneFarmaco assunzioneFarmaco, bool completed) async {
    AssunzioneFarmaco updated = await _service.setCompleted(assunzioneFarmaco, completed);
    state = [
      for (final assunzione in state) updated.id == assunzione.id ? updated : assunzione,
    ];
  }
}

final currentTherapyProvider = StateProvider<Terapia?>((ref) {
  return null;
});

final assunzioniTherapyProvider = Provider<List<AssunzioneFarmaco>>((ref) {
  int? therapyId = ref.watch(currentTherapyProvider)?.id;
  List<AssunzioneFarmaco> list = ref.watch(assunzioniFarmacoProvider);
  return list.where((element) => therapyId == null || element.idTerapia == therapyId).toList();
});

/*
// snippet per gestire async data in maniera alternativa a come ho fatto
Future<int> fetch() async => 42;

class Whatever extends StateNotifier<AsyncValue<int>> {
  Whatever(): super(const AsyncValue.loading()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetch());
  }
}

 */
