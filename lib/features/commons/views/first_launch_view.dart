
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:memo_med/features/family/model/user.dart';
import 'package:memo_med/features/commons/widgets/auto_unfocus.dart';

import 'package:memo_med/assets/avatar_images.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:memo_med/features/family/provider/users_provider.dart';
import 'package:memo_med/features/family/view/user_form.dart';
import 'package:memo_med/features/commons/widgets/form_elements/extended_button.dart';
import 'package:memo_med/features/commons/widgets/form_elements/text_input.dart';

class FirstView extends StatelessWidget {

  const FirstView({Key? key}) : super(key: key);

  static Route<dynamic> route({User? user}) {
    return MaterialPageRoute<dynamic>(builder: (_) => FirstView());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AutoUnfocus(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            title: const Text(
               "Benvenuto in MemoMed",
            ),
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
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
            child: const SafeArea(
              child: UserForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class UserForm extends ConsumerStatefulWidget {
  const UserForm({Key? key}) : super(key: key);

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
    _userName.text = "";
    selectedAvatar = (AvatarImage.avatarList..shuffle()).first;
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
      ref.read(usersProvider.notifier)
          .add(User(nome: _userName.text, avatarImage: selectedAvatar.imagePath));
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
                          showCupertinoModalBottomSheet(
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
                      labelText: "Come ti chiami?",
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
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Inizia!'),
            ),
          ),
        ],
      ),
    );
  }
}
