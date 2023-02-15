import 'package:flutter/material.dart';
import 'package:memo_med/features/commons/widgets/form_elements/select_input.dart';

import 'package:memo_med/features/family/model/user.dart';

class SelectFamilyMemberField extends StatelessWidget {
  final Function onSelectCallback;
  final List<User> userList;
  final User initialValue;
  final EdgeInsets? padding;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? accentColor;
  final Color? backgroundColor;
  final Color? errorColor;

  const SelectFamilyMemberField(
      {Key? key,
        required this.onSelectCallback,
        required this.initialValue,
        this.padding,
        this.primaryColor,
        this.secondaryColor,
        this.accentColor,
        this.backgroundColor,
        this.errorColor,
        required this.userList})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SelectField(
      labelText: "Membro della famiglia",
      itemHeight: 65,
      padding: padding,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      errorColor: errorColor,
      initialValue: initialValue,
      options: userList.map<SelectFieldMenuItem<User>>((User item) {
        return SelectFieldMenuItem<User>(
            value: item,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(item.avatarImage)),
                ),
                Flexible(child: Text(item.nome, overflow: TextOverflow.ellipsis,)),
              ],
            ));
      }).toList(),
      onSelectCallback: onSelectCallback,
    );
  }
}
