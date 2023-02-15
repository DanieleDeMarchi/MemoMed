import 'package:memo_med/features/appointments/appointments.dart';
import 'package:memo_med/features/appointments/model/appointment.dart';
import 'package:memo_med/utils/date_utils.dart';
import 'package:riverpod/riverpod.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final appointmentsDayProvider = Provider<List<Appointment>>((ref) {
  List<Appointment> appointments= ref.watch(appointmentsProvider);
  DateTime selectedDay= ref.watch(selectedDateProvider);
  return appointments.where((app) => isSameDay(app.data, selectedDay)).toList()..sort((a, b) => a.getDate().compareTo(b.getDate()));
});

final appointmentsWeekProvider = Provider<List<Appointment>>((ref) {
  List<Appointment> appointments= ref.watch(appointmentsProvider);
  DateTime selectedDay= ref.watch(selectedDateProvider);
  return appointments.where((app) => isSameWeek(app.data, selectedDay)).toList()..sort((a, b) => a.getDate().compareTo(b.getDate()));
});

final appointmentsMonthProvider = Provider<List<Appointment>>((ref) {
  List<Appointment> appointments= ref.watch(appointmentsProvider);
  DateTime selectedDay= ref.watch(selectedDateProvider);
  return appointments.where((app) => isSameMonth(app.data, selectedDay)).toList()..sort((a, b) => a.getDate().compareTo(b.getDate()));
});
