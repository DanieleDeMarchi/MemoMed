import 'dart:math';

import 'package:logger/logger.dart';
import 'package:memo_med/features/commons/service/notification-service.dart';
import 'package:memo_med/features/therapy/model/terapia.dart';
import 'package:memo_med/features/therapy/repository/therapy_repository.dart';

import '../model/assunzione_farmaco.dart';
import '../repository/assunzione_medicinali_reposirity.dart';

class TherapyService {
  static final TherapyService _therapyService = TherapyService._internal();

  late final TherapyRepository _therapyRepository;
  late final AssunzioneMedicinaliRepository _assunzioneMedicinaliRepository;
  late final NotificationService _notificationService;
  static final _logger = Logger();


  factory TherapyService() {
    return _therapyService;
  }

  TherapyService._internal(){
    _therapyRepository = TherapyRepository();
    _assunzioneMedicinaliRepository= AssunzioneMedicinaliRepository();
    _notificationService= NotificationService();
  }

  Future<List<Terapia>> getAll() {
    return _therapyRepository.getAll();
  }

  Future<Terapia> insertOne(Terapia terapia) async {
    Terapia newTerapia= await _therapyRepository.insert(terapia);
    List<AssunzioneFarmaco> assunzioni= _createAssunzioniFarmaco(newTerapia);
    _assunzioneMedicinaliRepository.insertMany(assunzioni, newTerapia.id!);
    if(terapia.isNotifica){
      List<int> notificationIds= await _scheduleNotifications(terapia, assunzioni);
      return _therapyRepository.updateOne(newTerapia.copyWith(idNotifiche: notificationIds));
    }
    return newTerapia;
  }

  Future<void> remove(Terapia terapia) async {
    _therapyRepository.delete(terapia.id!);
    terapia.idNotifiche?.forEach((id) { NotificationService().cancelNotification(id);});
  }

  List<AssunzioneFarmaco> _createAssunzioniFarmaco(Terapia terapia){
    List<AssunzioneFarmaco> assunzioni= [];
    List<DateTime> dateAssunzioni= [terapia.dataInizio];

    for (int i = 1; i < terapia.assunzioni; i++) {
      dateAssunzioni.add(terapia.dataInizio.add(terapia.frequenzaAssunzione!.frequenza * i));
    }

    for (int i = 0; i < terapia.assunzioni; i++) {
      assunzioni.insert(i, AssunzioneFarmaco(
          dataAssunzione: dateAssunzioni[i] ,
          completed: false,
          idTerapia: terapia.id!,
      ));
    }

    return assunzioni;
  }

  Future<List<int>> _scheduleNotifications(Terapia terapia, List<AssunzioneFarmaco> assunzioni) async {
    List<int> notificationIds= [];
    for (var a in assunzioni) {
      int? id= await NotificationService().schedule(
          title: "Promemoria Terapia",
          body: "È il momento di assumere un farmaco: ${terapia.farmaco}",
          notificationTime: a.dataAssunzione);
      if(id != null) {
        notificationIds.add(id);
      }
    }
    return notificationIds;
  }

  Future<Terapia> edit(Terapia t) {
    return _therapyRepository.updateOne(t);
  }

}