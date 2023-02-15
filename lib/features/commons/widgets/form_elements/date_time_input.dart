import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo_med/utils/date_utils.dart';

class DateTimeField extends StatefulWidget {
  final Function onDateChange;
  final Function onTimeChange;
  final EdgeInsets? padding;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? accentColor;
  final Color? backgroundColor;
  final Color? errorColor;
  final String dateLabel;
  final String hourLabel;
  final DateTime? initialDateTime;

  const DateTimeField({
    Key? key,
    required this.onDateChange,
    required this.onTimeChange,
    required this.dateLabel,
    required this.hourLabel,
    this.initialDateTime,
    this.padding,
    this.primaryColor,
    this.secondaryColor,
    this.accentColor,
    this.backgroundColor,
    this.errorColor,
  }) : super(key: key);

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  final TextEditingController _timeInputController = TextEditingController();
  final TextEditingController _dateInputController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();

  late Color? primaryColor;
  late Color? focusColor;
  late Color? accentColor;
  late Color? backgroundColor;
  late Color? errorColor;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.initialDateTime?.startOfDay ?? DateTime.now();
    _selectedTime = widget.initialDateTime == null
        ? TimeOfDay.now()
        : TimeOfDay.fromDateTime(widget.initialDateTime!);
    String formattedDate = DateFormat('EEE, M/d/y', 'it-IT').format(_selectedDate);
    _dateInputController.text = formattedDate; //set output date to TextField value.

    _timeInputController.text =
        "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}"; //set output date to TextField value.
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _dateInputController.dispose();
    _timeInputController.dispose();
    super.dispose();
  }

  setColors(BuildContext context) {
    primaryColor = widget.primaryColor ?? Theme.of(context).primaryColorDark;
    focusColor = widget.secondaryColor ?? Theme.of(context).primaryColorDark;
    accentColor = widget.accentColor ??
        Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide.color;
    backgroundColor = widget.backgroundColor ?? Theme.of(context).inputDecorationTheme.fillColor;
    errorColor = widget.errorColor ?? Theme.of(context).errorColor;
  }

  @override
  Widget build(BuildContext context) {
    setColors(context);

    return Padding(
      padding: widget.padding ?? const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: TextFormField(
                controller: _dateInputController,
                scrollPadding: const EdgeInsets.all(80), //editing controller of this TextField
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today),
                  prefixIconColor: primaryColor,
                  labelText: widget.dateLabel,
                  helperText: "",
                  helperStyle: const TextStyle(height: 0.5),
                  // prefixIcon: Icon(Icons.email),
                  filled: false,
                  fillColor: Colors.transparent,
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor!, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: focusColor!, width: 1.8),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: errorColor!, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor!, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                readOnly: true, //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    locale: const Locale('it', 'IT'),
                    initialDate: _selectedDate,
                    firstDate:
                        DateTime.now(), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101),
                    builder: (BuildContext context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          dialogTheme: DialogTheme(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  14.0), // this is the border radius of the picker
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    _selectedDate = pickedDate;
                    String formattedDate = DateFormat('EEE, M/d/y', 'it-IT').format(pickedDate);
                    setState(() {
                      _dateInputController.text =
                          formattedDate; //set output date to TextField value.
                    });
                    widget.onDateChange(pickedDate);
                  } else {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _timeInputController, //editing controller of this TextField
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.access_time_rounded),
                labelText: widget.hourLabel,
                helperText: "",
                helperStyle: const TextStyle(height: 0.5),
                // prefixIcon: Icon(Icons.email),
                filled: false,
                fillColor: Colors.transparent,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor!, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: focusColor!, width: 1.8),
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor!, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor!, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              readOnly: true, //set it true, so that user will not able to edit text
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  initialTime: _selectedTime,
                  context: context,
                  initialEntryMode: TimePickerEntryMode.dial,
                  builder: (BuildContext context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        timePickerTheme: TimePickerThemeData(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                14.0), // this is the border radius of the picker
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (pickedTime != null) {
                  _selectedTime = pickedTime;
                  setState(() {
                    _timeInputController.text =
                        "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}"; //set output date to TextField value.
                  });
                  widget.onTimeChange(pickedTime);
                } else {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
