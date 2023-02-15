import 'package:memo_med/features/commons/service/notification-service.dart';
import '../model/appointment.dart';
import '../repository/appointment_repository.dart';

class AppointmentsService {
  static final AppointmentsService _appointmentsService = AppointmentsService._internal();

  late final AppointmentRepository _appointmentsRepository;

  factory AppointmentsService() {
    return _appointmentsService;
  }

  AppointmentsService._internal(){
    _appointmentsRepository = AppointmentRepository();
  }

  Future<List<Appointment>> getAll() {
    return _appointmentsRepository.getAll();
  }

  Future<Appointment> insertOne(Appointment appointment) async {
    if(appointment.isNotifica){
      int? idNotifica= await NotificationService().schedule(
          title: "Promemoria Visita",
          body: "Non scordarti del tuo appuntamento: ${appointment.nome}",
          notificationTime: appointment.data
      );

      return _appointmentsRepository.insert(appointment.copyWith(idNotifica: idNotifica));
    }
    return _appointmentsRepository.insert(appointment);
  }

  Future<void> remove(Appointment appointment) {
    if(appointment.idNotifica != null){
      NotificationService().cancelNotification(appointment.idNotifica!);
    }
    return _appointmentsRepository.delete(appointment.id!);
  }

  Future<Appointment> setCompleted(Appointment appointment, bool completed) {
    Appointment updatedEntity= appointment.copyWith(completed: completed);
    return _appointmentsRepository.updateOne(updatedEntity);
  }

  Future<Appointment> edit(Appointment appointment) {
    return _appointmentsRepository.updateOne(appointment);
  }


}