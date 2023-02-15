import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentDateTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final currentDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});
