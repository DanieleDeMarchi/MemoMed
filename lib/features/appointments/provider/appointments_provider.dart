import 'package:memo_med/features/appointments/model/appointment.dart';
import 'package:memo_med/features/appointments/service/appointments_service.dart';
import 'package:memo_med/features/family/provider/provider.dart';
import 'package:riverpod/riverpod.dart';

final initialAppointmentsListProvider = FutureProvider((ref) async {
  ref.watch(usersProvider);
  return AppointmentsService().getAll();
});

final appointmentsProvider = StateNotifierProvider<AppointmentsNotifier, List<Appointment>>((ref) {
  var list = ref.watch(initialAppointmentsListProvider);
  return AppointmentsNotifier(list.value);
});

class AppointmentsNotifier extends StateNotifier<List<Appointment>> {
  late final AppointmentsService appointmentsService;

  AppointmentsNotifier([List<Appointment>? appuntamenti]) : super(appuntamenti ?? []) {
    appointmentsService = AppointmentsService();
  }

  Future<Appointment> add(Appointment appointment) async {
    Appointment added = await appointmentsService.insertOne(appointment);
    state = [...state, added];
    return added;
  }

  Future<Appointment> edit(Appointment appointment) async {
    Appointment updated = await appointmentsService.edit(appointment);
    state = [
      for (final app in state) app.id == appointment.id ? updated : app,
    ];
    return updated;
  }

  Future<void> setCompleted(Appointment appointment, bool completed) async {
    Appointment updated = await appointmentsService.setCompleted(appointment, completed);
    state = [
      for (final app in state) app.id == appointment.id ? updated : app,
    ];
  }

  Future<void> remove(Appointment appointment) async {
    await appointmentsService.remove(appointment);
    state = [
      for (final a in state)
        if (a.id != appointment.id) a,
    ];
  }
}
