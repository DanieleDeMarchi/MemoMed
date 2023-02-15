import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memo_med/features/commons/widgets/form_elements/tocomplete_badge.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentPageIndex;
  final void Function(int index, BuildContext context) bottomTapped;

  const MyBottomNavigationBar(this.currentPageIndex, this.bottomTapped,
      {Key? key})
      : super(key: key);

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: ToCompleteCountBadge(),
        label: 'Oggi',
      ),
      const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.houseMedical),
        label: 'Visite',
      ),
      const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.pills),
        label: 'Terapie',
      ),
      const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.peopleRoof),
        label: 'Famiglia',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomAppBarColor,
        border: const Border(top: BorderSide(color: Colors.black, width: 0.1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: currentPageIndex,
        onTap: (index) {
          bottomTapped(index, context);
        },
        items: buildBottomNavBarItems(),
        elevation: 0,
      ),
    );
  }
}
