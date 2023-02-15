import 'package:flutter/material.dart';
import 'package:memo_med/features/home/provider/provider.dart';

/// {@template home_body}
class HomeBody extends StatefulWidget {

  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> with AutomaticKeepAliveClientMixin<HomeBody>{
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  Widget detailPage(BuildContext context){
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text(
                'Back',
                style: TextStyle(fontSize: 32.0, color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainPage(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text(
            'PUSH',
            style: TextStyle(fontSize: 32.0, color: Colors.black),
          ),
          onPressed: () => Navigator.of(context).pushNamed("/detail"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState != null) {
          _navigatorKey.currentState!.maybePop();
          return false;
        }
        return true;
      },
      child: Navigator(
          key: _navigatorKey,
          initialRoute: "/",
          onGenerateRoute: (settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case '/':
                builder = (BuildContext context) => mainPage(context);
                break;
              case '/detail':
                builder = (BuildContext context) => detailPage(context);
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            return MaterialPageRoute<void>(builder: builder, settings: settings);
          }
      ),
    );
  }
}



