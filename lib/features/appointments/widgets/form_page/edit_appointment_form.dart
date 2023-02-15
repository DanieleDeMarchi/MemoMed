import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/appointments/appointments.dart';
import 'package:memo_med/features/appointments/model/appointment.dart';
import 'package:memo_med/features/commons/model/tempoPreavviso.dart';
import 'package:memo_med/features/family/provider/provider.dart';
import 'package:memo_med/utils/date_utils.dart';
import 'package:memo_med/features/commons/widgets/widgets.dart';
import 'package:memo_med/features/family/model/user.dart';
import 'package:memo_med/features/commons/widgets/form_elements/notification_field.dart';

import '../../view/detail_page.dart';

class AppointmentsForm extends ConsumerStatefulWidget {
  final Appointment? appointment;
  const AppointmentsForm({Key? key, this.appointment}) : super(key: key);

  @override
  AppointmentsFormState createState() {
    return AppointmentsFormState();
  }
}

class AppointmentsFormState extends ConsumerState<AppointmentsForm> {
  final _formKey = GlobalKey<FormState>();

  late bool isNew;

  late TextEditingController _nomeVisitaController;
  late TextEditingController _noteInputController;
  late TextEditingController _luogoController;
  late TextEditingController _indirizzoController;

  late TimeOfDay _selectedTime;
  late DateTime _selectedDate;
  late DateTime _dateTime;
  late User _selectedUser;
  late PreavvisoNotifica _preavvisoNotifica;
  late bool _isNotificationActive;

  void dropdownCallback(PreavvisoNotifica selectedValue) {
    _preavvisoNotifica = selectedValue;
  }

  void onTimeSelected(TimeOfDay time) {
    _selectedTime = time;
  }

  void onDateSelected(DateTime dateTime) {
    _selectedDate = dateTime;
  }

  void onSelectUser(User u) {
    _selectedUser = u;
  }

  Future<Appointment> onFormSubmit(BuildContext context) {
    _dateTime =
        _selectedDate.add(Duration(hours: _selectedTime.hour, minutes: _selectedTime.minute));

    Appointment appointment = Appointment(
        id: widget.appointment?.id,
        nome: _nomeVisitaController.text,
        data: _dateTime,
        user: _selectedUser,
        luogo: _luogoController.text,
        indirizzo: _indirizzoController.text,
        isNotifica: _isNotificationActive,
        preavvisoNotifica: _preavvisoNotifica,
      note: _noteInputController.text
    );

    if (isNew) {
      return ref.read(appointmentsProvider.notifier).add(appointment);
    } else {
      return ref.read(appointmentsProvider.notifier).edit(appointment);
    }
  }

  @override
  void initState() {
    super.initState();
    isNew = widget.appointment == null;

    _selectedTime = isNew ? TimeOfDay.now() : TimeOfDay.fromDateTime(widget.appointment!.data);
    _selectedDate = widget.appointment?.data.startOfDay ?? DateTime.now().startOfDay;
    _preavvisoNotifica = widget.appointment?.preavvisoNotifica ?? PreavvisoNotifica.values.first;
    _isNotificationActive = widget.appointment?.isNotifica ?? true;
    _nomeVisitaController = TextEditingController();
    _luogoController = TextEditingController();
    _noteInputController = TextEditingController();
    _indirizzoController = TextEditingController();

    if (!isNew) {
      _nomeVisitaController.text = widget.appointment!.nome;
      _luogoController.text = widget.appointment!.luogo ?? "";
      _indirizzoController.text = widget.appointment!.indirizzo ?? "";
      _noteInputController.text = widget.appointment!.note ?? "";
    }
  }

  @override
  void dispose() {
    _nomeVisitaController.dispose();
    _luogoController.dispose();
    _indirizzoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final futureUsers = ref.watch(userListProvider);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  futureUsers.when(data: (List<User> users) {
                    _selectedUser = isNew ? users.first : widget.appointment!.user;
                    return SelectFamilyMemberField(
                      padding: const EdgeInsets.only(left: 7.0, right: 7.0, bottom: 8.0, top: 20.0),
                      onSelectCallback: onSelectUser,
                      userList: users,
                      initialValue: _selectedUser,
                    );
                  }, error: (Object error, StackTrace stackTrace) {
                    return const SizedBox.shrink();
                  }, loading: () {
                    return const SizedBox.shrink();
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: TextInputField(
                      inputController: _nomeVisitaController,
                      autoFocus: false,
                      hintText: "es: Prelievo del sangue",
                      labelText: "Titolo",
                      helperText: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Per favore, compila questo campo';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextInputField(
                    inputController: _luogoController,
                    helperText: "(Opzionale)",
                    hintText: "es: Ospedale di Treviso",
                    labelText: "Luogo",
                  ),
                  TextInputField(
                    inputController: _indirizzoController,
                    helperText: "(Opzionale)",
                    hintText: "es: Piazzale dell'Ospedale, 1, Treviso",
                    labelText: "Indirizzo",
                  ),
                  DateTimeField(
                    onTimeChange: onTimeSelected,
                    onDateChange: onDateSelected,
                    dateLabel: "Data",
                    hourLabel: "Ora",
                    initialDateTime: widget.appointment?.data,
                  ),
                  NotificationField(
                    initialValueIsNotification: _isNotificationActive,
                    initialValuePreavviso: _preavvisoNotifica,
                    onIsNotificaChange: (value) => _isNotificationActive = value,
                    onIsPreavvisoChange: (value) => _preavvisoNotifica = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 100.0),
                    child: TextInputField(
                      inputController: _noteInputController,
                      scrollPadding: const EdgeInsets.all(120.0),
                      minLines: 4,
                      maxLines: 8,
                      hintText: "es: Presentarsi a stomaco vuoto",
                      helperText: "(Opzionale)",
                      labelText: "Note aggiuntive",
                    ),
                  ),
                ],
              ),
            ),
          ),
          SubmitButton(
            text: isNew ? 'Aggiungi' : 'Salva modifiche',
            callbackFunction: () {
              if (_formKey.currentState!.validate()) {
                Future<Appointment> app = onFormSubmit(context);
                app.then((appointment) {
                  if (isNew) {
                    Navigator.of(context)
                        .pushReplacement(AppointmentDetailPage.route(appointment));
                  } else {
                    Navigator.of(context).pop(appointment);
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
