import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:memo_med/features/commons/widgets/widgets.dart';
import 'package:memo_med/features/appointments/appointments.dart';
import 'package:memo_med/features/family/provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as bottomSheet;

import 'package:memo_med/assets/avatar_images.dart';
import '../model/user.dart';

class UserFormView extends StatelessWidget {
  final User? user;

  const UserFormView({Key? key, this.user}) : super(key: key);

  static Route<dynamic> route({User? user}) {
    return MaterialPageRoute<dynamic>(builder: (_) => UserFormView(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return AutoUnfocus(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            user == null ? "Nuovo membro famiglia" : "Modifica membro famiglia",
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surfaceVariant,
              Theme.of(context).backgroundColor,
              Theme.of(context).backgroundColor,
            ],
          )),
          child: SafeArea(
            child: UserForm(
              userToEdit: user,
            ),
          ),
        ),
      ),
    );
  }
}

class UserForm extends ConsumerStatefulWidget {
  final User? userToEdit;
  const UserForm({Key? key, this.userToEdit}) : super(key: key);

  @override
  UserFormState createState() {
    return UserFormState();
  }
}

class UserFormState extends ConsumerState<UserForm> {
  var logger = Logger();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userName = TextEditingController();

  late AvatarImage selectedAvatar;

  @override
  void initState() {
    super.initState();
    _userName.text = widget.userToEdit != null ? widget.userToEdit!.nome : "";
    selectedAvatar = widget.userToEdit != null
        ? AvatarImage(widget.userToEdit!.avatarImage)
        : (AvatarImage.avatarList.toList()..shuffle()).first;
  }

  void selectAvatar(AvatarImage avatarImage) {
    setState(() {
      selectedAvatar = avatarImage;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _userName.dispose();
    super.dispose();
  }

  onSaveUser() async {
    if (widget.userToEdit != null) {
      ref.read(usersProvider.notifier).edit(User(
            id: widget.userToEdit!.id,
            nome: _userName.text,
            avatarImage: selectedAvatar.imagePath,
          ));
      ref.invalidate(initialAppointmentsListProvider);
    } else {
      ref
          .read(usersProvider.notifier)
          .add(User(nome: _userName.text, avatarImage: selectedAvatar.imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                          bottomSheet.showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) => SizedBox(
                              height: 450,
                              child: AvatarGridView(
                                onSelect: selectAvatar,
                                selectedAvatar: selectedAvatar,
                              ),
                            ),
                            barrierColor: Colors.black38,
                            expand: false,
                          );
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.teal,
                              child: CircleAvatar(
                                radius: 76,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 78,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(selectedAvatar.imagePath),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Cambia immagine",
                                style: TextStyle(color: Colors.black87),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                    child: TextInputField(
                      inputController: _userName,
                      scrollPadding: EdgeInsets.zero,
                      autoFocus: false,
                      hintText: "Mario Rossi",
                      labelText: "Nome",
                      helperText: "",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Per favore, compila questo campo';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 20.0),
            child: ExtendedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  onSaveUser();
                  Navigator.pop(context);
                }
              },
              child: Text(widget.userToEdit != null ? 'Modifica' : 'Aggiungi'),
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarGridView extends StatefulWidget {
  final Function(AvatarImage avatarImage) onSelect;
  final AvatarImage selectedAvatar;

  const AvatarGridView({Key? key, required this.onSelect, required this.selectedAvatar})
      : super(key: key);

  @override
  State<AvatarGridView> createState() => _AvatarGridViewState();
}

class _AvatarGridViewState extends State<AvatarGridView> {
  late AvatarImage selectedAvatar;

  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.selectedAvatar;
  }

  void selectAvatar(AvatarImage avatarImage) {
    setState(() {
      selectedAvatar = avatarImage;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GridView.count(
        controller: bottomSheet.ModalScrollController.of(context),
        crossAxisCount: 4,
        children: AvatarImage.avatarList
            .map(
              (avatar) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    selectAvatar(avatar);
                    widget.onSelect(avatar);
                    await Future.delayed(const Duration(milliseconds: 100));
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: avatar == selectedAvatar ? Colors.teal : Colors.black12,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(avatar.imagePath),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
