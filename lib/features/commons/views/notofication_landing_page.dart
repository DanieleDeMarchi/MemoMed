import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NotificationLandingPage extends StatelessWidget {
  const NotificationLandingPage({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const NotificationLandingPage());
  }

  onComplete(BuildContext context){
    Navigator.of(context).pop();
  }

  onSkip(BuildContext context){
    Navigator.of(context).pop();
  }

  onDelay(BuildContext context){
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
            iconSize: 35,
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [0, 0.8, 1],
            colors: [
              Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).backgroundColor,
              Theme.of(context).backgroundColor,
              Theme.of(context).backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.pills,
                        color: Theme.of(context).primaryColorDark,
                        size: 140,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text("Terapia"),
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: LinearPercentIndicator(
                                  percent: 0.5,
                                  lineHeight: 6,
                                  animation: true,
                                  progressColor: Theme.of(context).primaryColor,
                                  backgroundColor: Color(0xFFDCDCDC),
                                  barRadius: Radius.circular(10),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () => {},
                          label: Text("Completato"),
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 20)),
                            minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
                            alignment: Alignment.center,
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(right: 75, left: 75, top: 18, bottom: 18)),
                            backgroundColor:
                                MaterialStateProperty.all(Theme.of(context).primaryColorDark),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: OutlinedButton.icon(
                                    icon: Icon(
                                      Icons.keyboard_double_arrow_right,
                                      color: Theme.of(context).primaryColorDark,
                                      size: 25.0,
                                    ),
                                    onPressed: () => {},
                                    label: Text("Skip"),
                                    style: ButtonStyle(
                                      textStyle:
                                          MaterialStateProperty.all(const TextStyle(fontSize: 18)),
                                      minimumSize:
                                          MaterialStateProperty.all(const Size.fromHeight(50)),
                                      elevation: MaterialStateProperty.all(0),
                                      alignment: Alignment.center,
                                      side: MaterialStateProperty.all(BorderSide(
                                        color: Theme.of(context).primaryColorDark,
                                      )),
                                      backgroundColor: MaterialStateProperty.all(
                                          Theme.of(context).bottomAppBarColor),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: OutlinedButton.icon(
                                    icon: Icon(
                                      Icons.schedule_outlined,
                                      color: Theme.of(context).primaryColorDark,
                                      size: 25.0,
                                    ),
                                    onPressed: () => {},
                                    label: Text("Rimanda"),
                                    style: ButtonStyle(
                                      textStyle:
                                          MaterialStateProperty.all(const TextStyle(fontSize: 18)),
                                      minimumSize:
                                          MaterialStateProperty.all(const Size.fromHeight(50)),
                                      alignment: Alignment.center,
                                      side: MaterialStateProperty.all(BorderSide(
                                        color: Theme.of(context).primaryColorDark,
                                      )),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
