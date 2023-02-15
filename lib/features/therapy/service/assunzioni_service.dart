import 'package:logger/logger.dart';
import 'package:memo_med/features/therapy/model/assunzione_farmaco.dart';
import 'package:memo_med/features/therapy/repository/assunzione_medicinali_reposirity.dart';

import 'package:memo_med/features/commons/service/notification-service.dart';

class AssunzioniService {
  static final AssunzioniService _assunzioniService = AssunzioniService._internal();

  late final AssunzioneMedicinaliRepository _assunzioneMedicinaliRepository;
  late final NotificationService _notificationService;
  static final _logger = Logger();


  factory AssunzioniService() {
    return _assunzioniService;
  }

  AssunzioniService._internal(){
    _assunzioneMedicinaliRepository= AssunzioneMedicinaliRepository();
    _notificationService= NotificationService();
  }

  Future<List<AssunzioneFarmaco>> getAll() {
    return _assunzioneMedicinaliRepository.getAll();
  }

  Future<AssunzioneFarmaco> setCompleted(AssunzioneFarmaco a, bool completed) {
    AssunzioneFarmaco updated= a.copyWith(completed: completed);
    return _assunzioneMedicinaliRepository.update(updated);
  }

}