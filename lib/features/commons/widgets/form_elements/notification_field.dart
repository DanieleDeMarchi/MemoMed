import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import 'package:memo_med/features/commons/model/tempoPreavviso.dart';
import 'package:memo_med/features/commons/service/notification-service.dart';
import 'package:memo_med/features/commons/widgets/form_elements/select_input.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationField extends StatefulWidget {
  final bool initialValueIsNotification;
  final PreavvisoNotifica initialValuePreavviso;
  final Function onIsNotificaChange;
  final Function onIsPreavvisoChange;
  const NotificationField({
    Key? key,
    required this.initialValueIsNotification,
    required this.initialValuePreavviso,
    required this.onIsNotificaChange,
    required this.onIsPreavvisoChange,
  }) : super(key: key);

  @override
  State<NotificationField> createState() => _NotificationFieldState();
}

class _NotificationFieldState extends State<NotificationField> {
  late bool _isNotification;
  late PreavvisoNotifica _preavvisoNotifica;
  late Future<PermissionStatus> permissionStatus;

  @override
  void initState() {
    super.initState();
    _isNotification = widget.initialValueIsNotification;
    _preavvisoNotifica = widget.initialValuePreavviso;
    permissionStatus = NotificationService().getNotificationPermissionStatus();
  }

  void onChange(bool value) async {
    bool newValue;
    if (!value) {
      newValue= false;
    } else {
      PermissionStatus status= await NotificationService().askForNotificationPermission();
      if(status.isPermanentlyDenied || status.isDenied){
        showNotificationDisabledDialog();
      }
      newValue= status.isGranted && value;
    }

    permissionStatus= NotificationService().getNotificationPermissionStatus();

    setState(() {
      _isNotification = newValue;
      widget.onIsNotificaChange(newValue);
    });
  }

  Future<void> showNotificationDisabledDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Notifiche disabilitate'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Le notifiche sono disabilitate per questa applicazione.'),
                Text('Vuoi modificare questa impostazione?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla', style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Vai a Impostazioni'),
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openNotificationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: permissionStatus,
          builder: (context, snapshot) {
            bool value;
            if (snapshot.hasData) {
              PermissionStatus status = snapshot.data as PermissionStatus;
              value = status.isGranted && _isNotification;
            } else {
              value = false;
            }
            return SwitchListTile(
              title: const Text('Promemoria'),
              value: value,
              contentPadding: const EdgeInsets.fromLTRB(12.0, 8.0, 18.0, 2.0),
              onChanged: onChange,
              secondary: const Icon(Icons.notification_add),
            );
          },
        ),
        if (_isNotification)
          SelectField(
              labelText: "Notifica",
              initialValue: _preavvisoNotifica,
              options: PreavvisoNotifica.values
                  .map<SelectFieldMenuItem<PreavvisoNotifica>>((PreavvisoNotifica item) {
                return SelectFieldMenuItem<PreavvisoNotifica>(
                    value: item, child: Text(item.toDropdownString()));
              }).toList(),
              onSelectCallback: (value) {
                _preavvisoNotifica = value;
                widget.onIsPreavvisoChange(value);
              }),
      ],
    );
  }
}
