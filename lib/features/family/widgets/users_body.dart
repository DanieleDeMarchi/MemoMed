import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:memo_med/features/family/provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/family/users.dart';

import '../model/user.dart';
import '../view/user_form.dart';

enum ContextMenuOption {
  delete("Elimina", Icon(Icons.delete, color: Colors.redAccent,)),
  update ("Modifica", Icon(Icons.edit));

  final String menuString;
  final Icon menuIcon;

  const ContextMenuOption(this.menuString, this.menuIcon);
}

class UsersBody extends ConsumerWidget {
  const UsersBody({Key? key}) : super(key: key);

  List<Widget> buildWidgetList(BuildContext contex, List<User> users) {
    //lista membri famiglia
    final widgetList = users.map((e) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: FamilyMemberTile(user: e),
      );
    }).toList();
    //bottone "aggiungi" per aggiungere membro della famiglia
    widgetList.add(
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        child: AddFamilyMemberButton(),
      ),
    );
    //bottom padding per alzare la lista (motivi estetici)
    widgetList.add(const Padding(padding: EdgeInsets.only(bottom: 90)));
    return widgetList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<User> users = ref.watch(usersProvider);
    return Center(
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: buildWidgetList(context, users),
      ),
    );
  }
}

class FamilyMemberTile extends StatelessWidget {
  final User user;
  final _popupButtonKey = GlobalKey<State>();
  FamilyMemberTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: Theme.of(context).appBarTheme.foregroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          dynamic state = _popupButtonKey.currentState;
          state.showButtonMenu();
        },
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.teal,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundImage: AssetImage(user.avatarImage),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 35.0),
                    child: Center(
                      child: AutoSizeText(
                        user.nome,
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                        textAlign: TextAlign.center,
                        minFontSize: 18,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 2.0,
              top: 2.0,
              child: ContextualMenu(user: user, contextualMenuKey: _popupButtonKey),
            ),
          ],
        ),
      ),
    );
  }
}

class ContextualMenu extends StatelessWidget {
  final User user;
  final Key contextualMenuKey;
  const ContextualMenu({Key? key, required this.user, required this.contextualMenuKey}) : super(key: key);

  onSelected(BuildContext context, ContextMenuOption selectedOption){
    switch(selectedOption) {
      case ContextMenuOption.update:
        return updateUser(context);
      case ContextMenuOption.delete:
        return deleteUser(context);
    }
  }

  deleteUser(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => DeleteUserAlertDialog(user)
    );
  }

  updateUser(BuildContext context){
    Navigator.of(context).push(UserFormView.route(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ContextMenuOption>(
      offset: const Offset(-3.0, 3.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      key: contextualMenuKey,
      onSelected: (ContextMenuOption selectedOption) => onSelected(context, selectedOption),
      icon: const Icon(
        Icons.more_horiz_outlined,
        color: Colors.white70,
      ),
      itemBuilder: (BuildContext context) {
        return ContextMenuOption.values.map((menuItem) => PopupMenuItem<ContextMenuOption>(
          value: menuItem,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: menuItem.menuIcon,
              ),
              Text(
                menuItem.menuString,
                style: const TextStyle(fontSize: 19),
              ),
            ],
          ),
        )).toList();
      },
    );
  }
}

class DeleteUserAlertDialog extends ConsumerWidget {
  final User user;

  const DeleteUserAlertDialog(this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<User> users = ref.watch(usersProvider);

    if(users.length == 1){
      return AlertDialog(
        title: const Text("Impossibile eliminare"),
        content: const Text("Non è possibile eliminare tutti i membri della famiglia.\n"
            "Aggiungi un altro utente per poter rimuovere questo familiare."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actions: [
          // The "Yes" button
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok')),
        ],
      );
    }

    return AlertDialog(
      title: const Text("Conferma eliminazione"),
      content: const Text('Sei sicuro di voler eliminare questo membro della famiglia?'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        // The "Yes" button
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annulla')),
        TextButton(
            onPressed: () async {
              String deleteUserName= user.nome;
              await ref.read(usersProvider.notifier).remove(this.user);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Utente $deleteUserName rimosso")));
            },
            child: const Text('Elimina', style: (TextStyle(color: Colors.red)),))
      ],
    );
  }
}

class AddFamilyMemberButton extends ConsumerWidget {
  const AddFamilyMemberButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DottedBorder(
      color: Colors.white,
      strokeWidth: 2,
      dashPattern: const [8, 12],
      radius: const Radius.circular(20),
      borderType: BorderType.RRect,
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white24, Colors.white10],
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(UserFormView.route());
          },
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                Text(
                  "Aggiungi",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
