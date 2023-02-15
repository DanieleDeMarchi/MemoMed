import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:memo_med/utils/date_utils.dart' as date_utils;
import 'package:memo_med/utils/date_utils.dart';

class Calendar extends StatefulWidget {
  const Calendar(
      {Key? key,
      required this.color,
      this.markerColor,
      this.onChange,
      this.initialDate,
      this.weekFormat = false,
      this.weekStartsMonday = false,
      this.iconColor,
      this.dateStyle,
      this.dayOfWeekStyle,
      this.inactiveDateStyle,
      this.selectedDateStyle,
      this.titleStyle,
      this.rowHeight,
      this.locale,
      this.events})
      : super(key: key);

  final bool weekFormat;
  final bool weekStartsMonday;
  final Color color;
  final Color? markerColor;
  final void Function(DateTime?)? onChange;
  final DateTime? initialDate;
  final Color? iconColor;
  final TextStyle? dateStyle;
  final TextStyle? dayOfWeekStyle;
  final TextStyle? inactiveDateStyle;
  final TextStyle? selectedDateStyle;
  final TextStyle? titleStyle;
  final double? rowHeight;
  final String? locale;
  final List<DateTime>? events;

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime focusedDay;
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    focusedDay = widget.initialDate ?? DateTime.now();
    selectedDay = widget.initialDate ?? DateTime.now();
  }

  CalendarFormat get calendarFormat =>
      widget.weekFormat ? CalendarFormat.week : CalendarFormat.month;

  StartingDayOfWeek get startingDayOfWeek =>
      widget.weekStartsMonday ? StartingDayOfWeek.monday : StartingDayOfWeek.sunday;

  Color get color => widget.color;
  Color get lightColor => widget.color.withOpacity(0.85);
  Color get lighterColor => widget.color.withOpacity(0.60);

  void setSelectedDay(DateTime? newSelectedDay) {
    setState(() {
      selectedDay = newSelectedDay ?? selectedDay;
      focusedDay = newSelectedDay ?? selectedDay;
      if (widget.onChange != null) {
        widget.onChange!(newSelectedDay);
      }
    });
  }

  showFullCalendar(String locale) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        DateTime firstDate = DateTime.now().subtract(Duration(days: DateTime.now().day -1));
        DateTime endDate = DateTime.now().add(const Duration(days: 365*5));
        double height = (MediaQuery.of(context).size.height - 100.0);

        return SizedBox(
          height: height,
          ///usage of full calender widget, which is defined below
          child: FullCalendar(
            height: height,
            startDate: firstDate,
            endDate: endDate,
            padding: 5,
            accent: color,
            black: Colors.black,
            white: Colors.white,
            events: widget.events ?? [],
            selectedDate: selectedDay,
            locale: locale,
            onDateChange: (date) {
              Navigator.pop(context);
              setSelectedDay(date);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CalendarHeader(
          focusedDay: focusedDay,
          onLeftChevronTap: () => setState(
            () => focusedDay =
                widget.weekFormat ? previousWeek(focusedDay) : previousMonth(focusedDay),
          ),
          onRightChevronTap: () => setState(
            () => focusedDay = widget.weekFormat ? nextWeek(focusedDay) : nextMonth(focusedDay),
          ),
          onCalendarIconTap: () => showFullCalendar('it'),
          // onMonthTap: () => showFullCalendar('it'),
          titleStyle: widget.titleStyle,
          iconColor: widget.iconColor,
          locale: widget.locale,
        ),
        TableCalendar(
          focusedDay: focusedDay,
          selectedDayPredicate: (date) => date_utils.isSameDay(selectedDay, date),
          firstDay: kFirstDay,
          lastDay: kLastDay,
          calendarFormat: calendarFormat,
          headerVisible: false,
          locale: widget.locale,
          eventLoader: (dateTime) {
            return widget.events?.where((date) => date_utils.isSameDay(date, dateTime)).toList() ??
                [];
          },
          rowHeight: widget.rowHeight ?? MediaQuery.of(context).size.width / 7,
          calendarStyle: CalendarStyle(
            weekendTextStyle: widget.dateStyle ?? const TextStyle(color: Color(0xFF5A5A5A)),
            holidayTextStyle: widget.dateStyle ?? const TextStyle(color: Color(0xFF5C6BC0)),
            selectedTextStyle:
                const TextStyle(color: Color(0xFFFAFAFA)).merge(widget.selectedDateStyle),
            todayTextStyle: const TextStyle(fontSize: 16.0).merge(widget.selectedDateStyle),
            outsideTextStyle:
                const TextStyle(color: Color(0xFF9E9E9E)).merge(widget.inactiveDateStyle),
            selectedDecoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              border: Border.all(color: lighterColor),
              color: lighterColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: widget.markerColor ?? lightColor,
              shape: BoxShape.circle,
            ),
            markerSize: 7,
            markerMargin: const EdgeInsets.symmetric(horizontal: 1.0),
            markersMaxCount: 3,
            canMarkersOverflow: false,
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          startingDayOfWeek: startingDayOfWeek,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: const TextStyle(color: Color(0xFF616161)).merge(widget.dayOfWeekStyle),
            weekendStyle: const TextStyle(color: Color(0xFF616161)).merge(widget.dayOfWeekStyle),
          ),
          onPageChanged: (date) {},
          onDaySelected: (newSelectedDay, _) {
            if (!date_utils.isSameDay(selectedDay, newSelectedDay)) {
              setSelectedDay(newSelectedDay);
              if (!date_utils.isSameMonth(focusedDay, newSelectedDay)) {
                setState(() => focusedDay = newSelectedDay);
              }
            }
          },
        ),
      ],
    );
  }
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
    // required this.onMonthTap,
    required this.onCalendarIconTap,
    this.iconColor,
    this.titleStyle,
    this.locale,
  }) : super(key: key);

  final DateTime focusedDay;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  // final VoidCallback onMonthTap;
  final VoidCallback onCalendarIconTap;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final String? locale;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(),
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(
              width: 20,
            ),
            Text(
              DateFormat.yMMMM(locale).format(focusedDay),
              style: const TextStyle(fontSize: 17).merge(titleStyle),
            ),
            // InkWell(
            //   // onTap: onMonthTap,
            //   child: Row(
            //     children: [
            //       Text(
            //         DateFormat.yMMMM(locale).format(focusedDay),
            //         style: const TextStyle(fontSize: 17).merge(titleStyle),
            //       ),
            //       Icon(Icons.arrow_drop_down_outlined, color: iconColor),
            //     ],
            //   ),
            // ),
            Expanded(child: Container()),
            CustomIconButton(
              margin: const EdgeInsets.only(right: 4.0),
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              icon: Icon(Icons.today, color: iconColor),
              onTap: onCalendarIconTap,
            ),
            CustomIconButton(
              margin: const EdgeInsets.only(right: 4.0),
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              icon: Icon(Icons.chevron_left, color: iconColor),
              onTap: onLeftChevronTap,
            ),
            CustomIconButton(
              margin: const EdgeInsets.only(left: 4.0, right: 8.0),
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              icon: Icon(Icons.chevron_right, color: iconColor),
              onTap: onRightChevronTap,
            ),
          ],
        ),
      );
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    this.padding = const EdgeInsets.all(10),
  }) : super(key: key);

  final Icon icon;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: padding,
            child: Icon(
              icon.icon,
              color: icon.color,
              size: icon.size,
            ),
          ),
        ),
      );
}

///  vedi https://pub.dev/packages/calendar_appbar
class FullCalendar extends StatefulWidget {
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime selectedDate;
  final Color? black;
  final Color? accent;
  final Color? white;
  final double? padding;
  final double? height;
  final String? locale;

  final List<DateTime>? events;

  final Function onDateChange;

  FullCalendar({
    Key? key,
    this.accent,
    this.endDate,
    required this.startDate,
    required this.padding,
    required this.selectedDate,
    this.events,
    this.black,
    this.white,
    this.height,
    this.locale,
    required this.onDateChange,
  }) : super(key: key);
  @override
  _FullCalendarState createState() => _FullCalendarState();
}

class _FullCalendarState extends State<FullCalendar> {
  late DateTime endDate;
  late DateTime startDate;
  late DateTime selectedDate;
  List<DateTime>? events = [];

  ///transforming variables to correct form
  @override
  void initState() {
    setState(() {
      startDate = widget.startDate;
      endDate = widget.endDate ?? DateTime(2050);
      selectedDate = widget.selectedDate;
      events = widget.events ?? [];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///calculating the height based of the screen height
    double width = MediaQuery.of(context).size.width - (2 * widget.padding!);

    ///definition of DateTime list dates
    List<DateTime?> dates = [];

    /// definition of [referenceDate]
    DateTime referenceDate = startDate.subtract(Duration(days: startDate.day - 1));

    ///creating list for calendar matrix
    while (referenceDate.isBefore(endDate)) {
      dates.add(referenceDate);

      ///adding next date
      referenceDate = referenceDate.add(const Duration(days: 1));
    }

    ///check if range is in the same month
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      return Padding(
        padding: EdgeInsets.fromLTRB(widget.padding!, 40.0, widget.padding!, 0.0),
        child: month(dates, width, widget.locale),
      );
    } else {
      ///creating the list of the month in the range
      List<DateTime?> months = [];
      for (int i = 0; i < dates.length; i++) {
        if (i == 0 || (dates[i]!.month != dates[i - 1]!.month)) {
          months.add(dates[i]);
        }
      }

      ///sort months
      months.sort((a, b) => a!.compareTo(b!));
      return Padding(
        padding: EdgeInsets.fromLTRB(widget.padding!, 40.0, widget.padding!, 0.0),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: months.length,
            itemBuilder: (context, index) {
              DateTime? date = months[index];
              List<DateTime?> daysOfMonth = [];
              for (var item in dates) {
                if (date!.month == item!.month && date.year == item.year) {
                  daysOfMonth.add(item);
                }
              }

              ///check if the date is the last
              bool isLast = index == 0;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0.0 : 25.0),
                child: month(daysOfMonth, width, widget.locale),
              );
            }),
      );
    }
  }

  ///definiton of week row that shows the day of the week for specific week
  Widget daysOfWeek(double width, String? locale) {
    List daysNames = [];
    for (var day = 12; day <= 19; day++) {
      daysNames
          .add(DateFormat.E(locale.toString()).format(DateTime.parse('1970-01-' + day.toString())));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        dayName(width / 7, daysNames[0]),
        dayName(width / 7, daysNames[1]),
        dayName(width / 7, daysNames[2]),
        dayName(width / 7, daysNames[3]),
        dayName(width / 7, daysNames[4]),
        dayName(width / 7, daysNames[5]),
        dayName(width / 7, daysNames[6]),
      ],
    );
  }

  ///definition of day widget
  Widget dayName(double width, String text) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12.0, fontWeight: FontWeight.w400, color: widget.black!.withOpacity(0.8)),
      ),
    );
  }

  ///definition of date in Calendar widget
  Widget dateInCalendar(DateTime date, bool outOfRange, double width, int eventCount) {
    ///comparing the date of current building widget with selected widget
    bool isSelectedDate = date_utils.isSameDay(selectedDate, date);
    return GestureDetector(
      onTap: () {
        if (!outOfRange) {
          selectedDate = date;
          setState(() {});
          widget.onDateChange(date);
        }
      },
      child: Container(
        width: width / 7,
        height: width / 7,
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  date_utils.isSameDay(DateTime.now(), date) ? widget.accent! : Colors.transparent),
          color: isSelectedDate
              ? widget.accent
              : date_utils.isSameDay(DateTime.now(), date)
                  ? widget.accent!.withOpacity(0.1)
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        //decoration: BoxDecoration(
        //    shape: BoxShape.circle, color: isSelectedDate ? widget.accent : Colors.transparent),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                DateFormat("dd").format(date),
                style: TextStyle(

                    ///UI of full calendar shows also the dates that are out
                    ///of the range defined by first and last date, although
                    ///the UI is different for the dates out of range
                    color: outOfRange || date.startOfDay.isBefore(DateTime.now().startOfDay)
                        ? isSelectedDate
                            ? widget.white!.withOpacity(0.9)
                            : widget.black!.withOpacity(0.4)
                        : isSelectedDate
                            ? widget.white
                            : widget.black),
              ),
            ),

            ///if there is an event on the specific date, UI will show dot in accent color
            if (eventCount > 0)
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    min(3, eventCount),
                    (_) => Container(
                      height: 5.0,
                      width: 7.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelectedDate ? widget.white : widget.accent),
                    ),
                  ))
            else
              const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }

  ///definition of month widget

  Widget month(List dates, double width, String? locale) {
    ///definition of first and initializing it on the first date int the month
    DateTime first = dates.first;
    while (DateFormat("E").format(dates.first) != "Mon") {
      ///add "empty fields" to the list to get offset of the days
      dates.add(dates.first.subtract(const Duration(days: 1)));

      ///sort all the dates
      dates.sort();
    }

    ///logically show all the dates in the month
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ///name of the month
        Text(
          DateFormat.yMMMM(Locale(locale!).toString()).format(first),
          style: TextStyle(fontSize: 18.0, color: widget.black, fontWeight: FontWeight.w400),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: daysOfWeek(width, widget.locale),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            ///calculate the number of rows with dates based on number of days in the month
            height: dates.length > 28
                ? dates.length > 35
                    ? 6 * width / 7
                    : 5 * width / 7
                : 4 * width / 7,
            width: MediaQuery.of(context).size.width - 2 * widget.padding!,

            ///show all days in the month
            child: GridView.builder(
              itemCount: dates.length,

              ///Since each calendar is drawn separatly it shouldn't be scrollable
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemBuilder: (context, index) {
                ///create date for each day in the month
                DateTime date = dates[index];

                ///check if it is empty field
                bool outOfRange = date.isBefore(startDate) || date.isAfter(endDate);

                ///if it is empty field return empty container
                if (date.isBefore(first)) {
                  return Container(
                    width: width / 7,
                    height: width / 7,
                    color: Colors.transparent,
                  );
                }

                ///otherwise return date container
                else {
                  return dateInCalendar(date, outOfRange, width,
                      events!.where((d) => date_utils.isSameDay(d, date)).length);
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
