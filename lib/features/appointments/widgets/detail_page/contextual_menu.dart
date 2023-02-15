import 'package:flutter/material.dart';

enum ContextMenuOption {
  delete("Elimina", Icon(Icons.delete, color: Colors.redAccent)),
  update("Modifica", Icon(Icons.edit, color: Colors.teal));

  final String menuString;
  final Icon menuIcon;

  const ContextMenuOption(this.menuString, this.menuIcon);
}

class ContextualMenu extends StatelessWidget {
  final Function onUpdate;
  final Function onDelete;
  const ContextualMenu({Key? key, required this.onDelete, required this.onUpdate}) : super(key: key);

  onSelected(BuildContext context, ContextMenuOption selectedOption) {
    switch (selectedOption) {
      case ContextMenuOption.update:
        return onUpdate();
      case ContextMenuOption.delete:
        return onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _popupButtonKey = GlobalKey<State>();

    return PopupMenuButton<ContextMenuOption>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      key: _popupButtonKey,
      onSelected: (ContextMenuOption selectedOption) => onSelected(context, selectedOption),
      icon: const Icon(
        Icons.more_vert_outlined,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext context) {
        return ContextMenuOption.values
            .map(
              (menuItem) => PopupMenuItem<ContextMenuOption>(
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
              ),
            )
            .toList();
      },
    );
  }
}
