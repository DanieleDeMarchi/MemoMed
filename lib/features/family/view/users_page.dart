import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memo_med/features/family/widgets/users_body.dart';


class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const UsersPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              elevation: 0.0,
              title: const Text(
                "Famiglia",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        preferredSize: const Size(
          double.infinity,
          56.0,
        ),
      ),



      backgroundColor: Theme.of(context).primaryColorDark,
      body: const UsersView(),
    );
  }
}

class UsersView extends StatelessWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UsersBody();
  }
}
