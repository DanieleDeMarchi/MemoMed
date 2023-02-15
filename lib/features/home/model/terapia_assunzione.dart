import 'package:memo_med/features/commons/activity.dart';
import 'package:memo_med/features/therapy/model/assunzione_farmaco.dart';

import '../../therapy/model/terapia.dart';

class TerapiaAssunzione implements Activity{
  final Terapia terapia;
  final AssunzioneFarmaco assunzioneFarmaco;
  final int index;

  TerapiaAssunzione(this.terapia, this.assunzioneFarmaco, this.index);

  get user => terapia.user;

  @override
  DateTime getDate() {
    return assunzioneFarmaco.dataAssunzione;
  }

  @override
  bool isCompleted() {
    return assunzioneFarmaco.completed;
  }
}