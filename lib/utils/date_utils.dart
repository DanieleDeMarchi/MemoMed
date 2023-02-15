DateTime kFirstDay = DateTime(1970, 1, 1);
DateTime kLastDay = DateTime(2100, 1, 1);

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59);
}

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isSameMonth(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month;
}

bool isSameWeek(DateTime a, DateTime b) {
  final startOfWeek1 = a.subtract(Duration(days: a.weekday - 1));
  final startOfWeek2 = b.subtract(Duration(days: b.weekday - 1));
  return isSameDay(startOfWeek1, startOfWeek2);
}

bool isInDayRange(DateTime? a, DateTime? start, DateTime? end) {
  if (a == null || start == null || end == null) {
    return false;
  }
  return isSameDay(a, start) ||
      isSameDay(a, end) ||
      a.startOfDay.isAfter(start) && a.startOfDay.isBefore(end) ;
}

bool isBeforeDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.startOfDay.isBefore(b.startOfDay);
}

bool isAfterDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }

  return a.startOfDay.isAfter(b.startOfDay);
}

DateTime previousWeek(DateTime week) {
  return week.subtract(const Duration(days: 7));
}

DateTime nextWeek(DateTime week) {
  return week.add(const Duration(days: 7));
}

DateTime previousMonth(DateTime month) {
  if (month.month == 1) {
    return DateTime(month.year - 1, 12);
  } else {
    return DateTime(month.year, month.month - 1);
  }
}

DateTime nextMonth(DateTime month) {
  if (month.month == 12) {
    return DateTime(month.year + 1, 1);
  } else {
    return DateTime(month.year, month.month + 1);
  }
}