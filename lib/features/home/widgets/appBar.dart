import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text('MemoMed'),
      backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize:
              Theme.of(context).appBarTheme.titleTextStyle?.fontSize ?? 24,
          fontWeight: FontWeight.w400),
      pinned: true,
    );
  }
}


/*
ToDo REMOVE
OLD IMPLEMENTATION

      actions: [
        SizedBox.fromSize(
          size: const Size(80, 50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.hardEdge,
              elevation: 2,
              child: InkWell(
                onTap: () {},
                child: Row(children: const [
                  Icon(Icons.more_vert),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage("assets/images/avatars/avatar_1.png"),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ],

 */
