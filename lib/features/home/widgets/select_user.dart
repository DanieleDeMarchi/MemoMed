import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_med/features/home/model/user_activity.dart';
import 'package:memo_med/features/home/widgets/progress_avatar.dart';
import 'package:memo_med/features/family/model/user.dart';

import '../provider/home_provider.dart';

class SelectFamilyMember extends ConsumerWidget {
  const SelectFamilyMember({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersWithActivities = ref.watch(todayActivitiesProvider);
    return UsersDropdown(usersWithActivities: usersWithActivities);
  }
}

class UsersDropdown extends ConsumerWidget {
  final Map<User, UserWithActivities> usersWithActivities;
  int _familyCount = 0;
  int _familyCompletedCount = 0;
  UsersDropdown({Key? key, required this.usersWithActivities}) : super(key: key);

  Widget selectedElement(UserWithActivities? selectedUser) {
    if (selectedUser == null) {
      return ProgressAvatar.large(
        title: "Famiglia",
        subTitle: "$_familyCompletedCount/$_familyCount completate",
        avatarImage: 'assets/images/avatars/family.png',
        progress: _familyCount > 0 ? _familyCompletedCount / _familyCount : 1,
        titleColor: Colors.white,
        subtitleColor: Colors.white70,
        progressBackground: Colors.white54,
        progressColor: Colors.white,
      );
    } else {
      int totalActivities = selectedUser!.getCount();
      int completedActivities = selectedUser!.getCompletedCount();

      return ProgressAvatar.large(
        title: selectedUser!.user.nome,
        subTitle: "$completedActivities/$totalActivities completate",
        avatarImage: selectedUser!.user.avatarImage,
        progress: totalActivities > 0 ? completedActivities / totalActivities : 1,
        titleColor: Colors.white,
        subtitleColor: Colors.white70,
        progressBackground: Colors.white54,
        progressColor: Colors.white,
      );
    }
  }

  List<DropdownMenuItem<UserWithActivities>> userList() {
    List<DropdownMenuItem<UserWithActivities>> list = [
      DropdownMenuItem<UserWithActivities>(
        value: null,
        child: ProgressAvatar.small(
          title: "Famiglia",
          subTitle: "$_familyCompletedCount/$_familyCount completate",
          avatarImage: 'assets/images/avatars/family.png',
          progress: _familyCompletedCount / _familyCount,
          titleColor: Colors.white,
          subtitleColor: Colors.white70,
          progressBackground: Colors.white54,
          progressColor: Colors.white,
        ),
      )
    ];

    list.addAll(usersWithActivities.values.map((element) {
      User user = element.user;
      int totalActivities = element.getCount();
      int completedActivities = element.getCompletedCount();
      return DropdownMenuItem<UserWithActivities>(
        value: element,
        child: ProgressAvatar.small(
          title: user.nome,
          subTitle: "$completedActivities/$totalActivities completate",
          avatarImage: user.avatarImage,
          progress: totalActivities > 0 ? completedActivities / totalActivities : 1,
          titleColor: Colors.white,
          subtitleColor: Colors.white70,
          progressBackground: Colors.white54,
          progressColor: Colors.white,
        ),
      );
    }));

    return list;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _familyCount = ref.watch(familyCountProvider);
    _familyCompletedCount = ref.watch(familyCompletedCountProvider);
    UserWithActivities? _selectedUser = ref.watch(selectedUserProvider);

    return DropdownButtonHideUnderline(
      child: DropdownButton2<UserWithActivities>(
        customButton: Container(
          color: Theme.of(context).appBarTheme.foregroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              selectedElement(_selectedUser),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        items: userList(),
        onChanged: (value) {
          ref.read(selectedUserProvider.notifier).state = value;
        },
        itemHeight: 60,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        //dropdownWidth: 160,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
        ),
        dropdownElevation: 8,
        offset: const Offset(5, 20),
        dropdownWidth: MediaQuery.of(context).size.width - 10,
      ),
    );
  }
}
