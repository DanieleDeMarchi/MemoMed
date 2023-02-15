import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/therapy/model/enums/frequenzaAssunzione.dart';
import 'package:memo_med/features/therapy/model/terapia.dart';
import 'package:memo_med/features/therapy/provider/assunzione_farmaco_provider.dart';
import 'package:memo_med/main.dart';
import 'package:memo_med/utils/date_utils.dart';
import 'package:memo_med/features/family/model/user.dart';
import 'package:memo_med/features/commons/widgets/widgets.dart';
import 'package:memo_med/features/family/provider/provider.dart';

import 'package:memo_med/features/commons/model/tempoPreavviso.dart';
import 'package:memo_med/features/commons/widgets/form_elements/notification_field.dart';

import '../../provider/therapy_provider.dart';
import '../../view/detail_page.dart';

class TherapyForm extends ConsumerStatefulWidget {
  final Terapia? therapy;
  const TherapyForm({Key? key, this.therapy}) : super(key: key);

  @override
  TherapyFormState createState() {
    return TherapyFormState();
  }
}

class TherapyFormState extends ConsumerState<TherapyForm> {
  final _formKey = GlobalKey<FormState>();

  late final bool isNew;

  late final TextEditingController farmacoInputController;
  late final TextEditingController noteInputController;

  late User _selectedUser;
  late TimeOfDay _selectedTime;
  late DateTime _selectedDate;
  late DateTime _dateTime;
  late bool _isNotificationActive;
  late int _numAssunzioni;
  late PreavvisoNotifica _preavvisoNotifica;
  late FrequenzaAssunzione _freaquenzaAssunzione;

  void onTimeSelected(TimeOfDay time) {
    _selectedTime = time;
    gLogger.i(_selectedTime);
  }

  void onDateSelected(DateTime dateTime) {
    _selectedDate = dateTime;
    gLogger.i(_selectedDate);
  }

  void onSelectUser(User u) {
    _selectedUser = u;
  }

  void onNumAssunzioniChange(int num) {
    _numAssunzioni = num;
  }

  void onFreqAssunzioniChange(FrequenzaAssunzione freq) {
    _freaquenzaAssunzione = freq;
  }

  Future<Terapia> onFormSubmit() {
    _dateTime = _selectedDate.add(Duration(
      hours: _selectedTime.hour,
      minutes: _selectedTime.minute,
    ));

    Terapia t = Terapia(
        id: widget.therapy?.id,
        farmaco: farmacoInputController.text,
        note: noteInputController.text,
        frequenzaAssunzione: _freaquenzaAssunzione,
        dataInizio: _dateTime,
        assunzioni: _numAssunzioni,
        isNotifica: _isNotificationActive,
        preavvisoNotifica: _preavvisoNotifica,
        user: _selectedUser);

    if (isNew) {
      return ref.watch(therapyProvider.notifier).add(t);
    } else {
      return ref.watch(therapyProvider.notifier).edit(t);
    }
  }

  @override
  void initState() {
    super.initState();
    isNew = widget.therapy == null;

    farmacoInputController = TextEditingController();
    noteInputController = TextEditingController();

    _preavvisoNotifica = isNew ? PreavvisoNotifica.FIVE_MINUTES : widget.therapy!.preavvisoNotifica ?? PreavvisoNotifica.FIVE_MINUTES;
    _freaquenzaAssunzione =
        isNew ? FrequenzaAssunzione.EIGHT_HOURS : widget.therapy!.frequenzaAssunzione!;
    _selectedTime = isNew ? TimeOfDay.now() : TimeOfDay.fromDateTime(widget.therapy!.dataInizio);
    _selectedDate = isNew ? DateTime.now().startOfDay : widget.therapy!.dataInizio.startOfDay;
    _isNotificationActive = isNew ? true : widget.therapy!.isNotifica;
    _numAssunzioni = isNew ? 6 : widget.therapy!.assunzioni;

    if (!isNew) {
      farmacoInputController.text = widget.therapy!.farmaco;
      noteInputController.text = widget.therapy!.note ?? '';
    }
  }

  @override
  void dispose() {
    farmacoInputController.dispose();
    noteInputController.dispose();
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
                    _selectedUser = isNew ? users.first : widget.therapy!.user;
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
                  TextInputField(
                    inputController: farmacoInputController,
                    hintText: "es: Tachipirina 1000",
                    labelText: "Farmaco",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Per favore, compila questo campo';
                      }
                      return null;
                    },
                  ),
                  //TextInputField(
                  //  inputController: nomeTerapiaInputController,
                  //  hintText: "es: Antibiotico per tosse 2 volte al giorno",
                  //  helperText: "(Opzionale)",
                  //  labelText: "Nome terapia",
                  //),
                  if (isNew)
                    DateTimeField(
                      onTimeChange: onTimeSelected,
                      onDateChange: onDateSelected,
                      dateLabel: "Data inizio",
                      hourLabel: "Ora",
                      initialDateTime: widget.therapy?.dataInizio,
                    ),
                  if (isNew)
                    NumAssunzioniField(
                      initialValueNumAssunzioni: _numAssunzioni,
                      initialValueFreqAssunzioni: _freaquenzaAssunzione,
                      onNumAssunzioniChange: onNumAssunzioniChange,
                      onFreqAssunzioniChange: onFreqAssunzioniChange,
                    ),
                  NotificationField(
                    initialValueIsNotification: _isNotificationActive,
                    initialValuePreavviso: _preavvisoNotifica,
                    onIsNotificaChange: (value) => _isNotificationActive = value,
                    onIsPreavvisoChange: (value) => _preavvisoNotifica = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextInputField(
                      inputController: noteInputController,
                      scrollPadding: const EdgeInsets.all(120.0),
                      minLines: 4,
                      maxLines: 8,
                      hintText: "es: Due compresse prima dei pasti",
                      helperText: "(Opzionale)",
                      labelText: "Note aggiuntive",
                    ),
                  ),
                ],
              ),
            ),
          ),
          SubmitButton(
            text: isNew ? 'Aggiungi' : 'Salva Modifiche',
            callbackFunction: () {
              if (_formKey.currentState!.validate()) {
                final result= onFormSubmit();
                result.then((t) {
                  if(isNew){
                    ref.read(currentTherapyProvider.notifier).state= t;
                    Navigator.of(context).pushReplacement(TherapyDetailPage.route());
                  } else {
                    ref.read(currentTherapyProvider.notifier).state= t;
                    Navigator.pop(context);
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

class NumAssunzioniField extends StatefulWidget {
  final int initialValueNumAssunzioni;
  final FrequenzaAssunzione initialValueFreqAssunzioni;
  final Function(int) onNumAssunzioniChange;
  final Function(FrequenzaAssunzione) onFreqAssunzioniChange;

  const NumAssunzioniField(
      {Key? key,
      required this.initialValueNumAssunzioni,
      required this.initialValueFreqAssunzioni,
      required this.onNumAssunzioniChange,
      required this.onFreqAssunzioniChange})
      : super(key: key);

  @override
  State<NumAssunzioniField> createState() => _NumAssunzioniFieldState();
}

class _NumAssunzioniFieldState extends State<NumAssunzioniField> {
  late int _numAssunzioni;
  late FrequenzaAssunzione _frequenzaAssunzione;
  final List<FrequenzaAssunzione> frequenzaAssunzioneOptions = FrequenzaAssunzione.values;

  @override
  void initState() {
    super.initState();
    _numAssunzioni = widget.initialValueNumAssunzioni;
    _frequenzaAssunzione = widget.initialValueFreqAssunzioni;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CounterTile(
          initialValue: _numAssunzioni,
          title: const Text(
            'Assunzioni',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          onChange: (value) {
            setState(() {
              _numAssunzioni = value;
            });
            widget.onNumAssunzioniChange(value);
          },
        ),
        if (_numAssunzioni > 1)
          SelectField(
              labelText: "Frequenza assunzione",
              initialValue: _frequenzaAssunzione,
              options: frequenzaAssunzioneOptions
                  .map<SelectFieldMenuItem<FrequenzaAssunzione>>((FrequenzaAssunzione item) {
                return SelectFieldMenuItem<FrequenzaAssunzione>(
                    value: item, child: Text(item.toDropdownString()));
              }).toList(),
              onSelectCallback: (value) {
                _frequenzaAssunzione = value;
                widget.onFreqAssunzioniChange(value);
              }),
      ],
    );
  }
}
