import 'dart:async';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:memo_med/features/commons/widgets/auto_unfocus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:convert';

import 'package:memo_med/features/commons/widgets/bottomNavBar.dart';
import 'package:memo_med/features/commons/widgets/switchable_fab.dart';

import 'package:memo_med/features/commons/provider/date_provider.dart';
import 'package:memo_med/features/commons/service/notification-service.dart';
import 'features/appointments/view/appointments_page.dart';
import 'features/commons/views/first_launch_view.dart';
import 'features/family/view/users_page.dart';
import 'features/home/view/home_page.dart';
import 'features/therapy/therapy.dart';

// navigatoKey variabile globale per accedere al Navigator principale in ogni parte del codice
// utilizzato per metodo handleNotification
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final Logger gLogger = Logger();

// metodo di callback quando viene aperta una notifica dell'applicazione
handleNotification(NotificationResponse notificationResponse) async {
  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

final cron = Cron();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setup tema applicazione
  final themeStr = await rootBundle.loadString('assets/theme/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  // setup package:timezone/timezone.dart per gestione date
  DateTime dateTime = DateTime.now();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(dateTime.timeZoneName));

  NotificationService().initialize(
    onDidReceiveBackgroundNotificationResponse: handleNotification,
    onDidReceiveNotificationResponse: handleNotification,
  );

  // entry point flutter app
  runApp(ProviderScope(
    child: MyApp(theme: theme),
  ));

  // se l'app è stata aperta da uno stato di terminazione,
  // tramite una modifica, invoca il metodo handleNotification
  NotificationService().handleNotificationAppLaunch(handleNotification);
}

class MyApp extends ConsumerWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  /// Aggiorna i provider di data e ora correnti utilizzando il package "cron".
  ///
  /// Il metodo utilizza due programmazioni cron per aggiornare i provider di data e ora correnti.
  /// La prima programmazione aggiorna il provider di ora corrente ogni minuto, mentre la seconda
  /// aggiorna il provider di data corrente ogni giorno alle 00:00.
  ///
  /// @param ref WidgetRef per i provider di data e ora correnti.
  updateDateTimeProvider(WidgetRef ref) {
    cron.schedule(
      Schedule.parse('* * * * *'),
      () => ref.read(currentDateTimeProvider.notifier).state = DateTime.now(),
    );
    cron.schedule(
      Schedule.parse('00 00 * * *'),
      () => ref.read(currentDateProvider.notifier).state = DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    updateDateTimeProvider(ref);
    return AutoUnfocus(
      child: MaterialApp(
        title: 'MemoMed',
        debugShowCheckedModeBanner: false,
        theme: theme,
        navigatorKey: navigatorKey,
        home: const MainPage(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('it')],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPageIndex = 0;
  Color _statusBarColor = Colors.white;

  List<Widget> pages() {
    return [
      const HomePage(),
      const AppointmentsPage(),
      const TherapyPage(),
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if(prefs.getBool("firstLaunch") == null || prefs.getBool("firstLaunch") == false){
        bool created= await Navigator.of(context).push(FirstView.route());
        prefs.setBool("firstLaunch", created);
      }
    });
  }

  void changeView(int index, BuildContext context) {
    if (index == 3) {
      Navigator.push(context, UsersPage.route());
      return;
    }

    if (index != _currentPageIndex) {
      setState(() {
        _currentPageIndex = index;
        setStatusBarColor(index, context);
      });
    }
  }

  setStatusBarColor(int pageIndex, BuildContext context) {
    switch (pageIndex) {
      case 0:
        _statusBarColor = Theme.of(context).appBarTheme.foregroundColor ?? Colors.white;
        break;
      case 1:
      case 2:
        _statusBarColor = Theme.of(context).appBarTheme.backgroundColor ?? Colors.white;
        break;
      default:
        _statusBarColor = Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(_currentPageIndex, context);

    return Scaffold(
      // appBar di altezza 0, trick per cambiare il colore della status bar senza fare salti mortali
      // forse non efficiente ma comodo
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: _statusBarColor,
      ),
      body: SafeArea(
        // uso di indexed stack per gestire navigazione
        // la views non viene rimossa quando si cambia pagina, così si preserva la posizione dello
        // scroll in ogni pagina. (alternativa AutomaticKeepAliveClientMixin su ogni views)
        child: IndexedStack(
          index: _currentPageIndex,
          children: pages(),
        ),
      ),
      //backgroundColor: Colors.white,
      bottomNavigationBar: MyBottomNavigationBar(_currentPageIndex, changeView),
      floatingActionButton: SwitchableFab(_currentPageIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      extendBodyBehindAppBar: true,
      extendBody: true,
    );
  }
}
