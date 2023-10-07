import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_strategy/url_strategy.dart';

import 'AllNew/screens/Notifications/local_notifications.dart';
import 'AllNew/screens/wrapper.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 365));
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalNotificationService localNotificationService =
      LocalNotificationService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // initial state of the switch
    bool darkModeEnabled = false;

    MaterialColor myColor = const MaterialColor(
      0xE7791971,
      <int, Color>{
        50: Color(0xE7791971),
        100: Color(0xE7791971),
        200: Color(0xE7791971),
        300: Color(0xE7791971),
        400: Color(0xE7791971),
        500: Color(0xE7791971),
        600: Color(0xE7791971),
        700: Color(0xE7791971),
        800: Color(0xE7791971),
        900: Color(0xE7791971),
      },
    );

    // Define light and dark themes
    final ThemeData lightTheme = ThemeData(
      primarySwatch: myColor,
      primaryColorDark: const Color(0xE7791971),
      primaryColorLight: Colors.white,
      fontFamily: 'Poppins',
      iconTheme: const IconThemeData(
        color: Color(0xE7791971),
      ),
    );
    final ThemeData darkTheme = ThemeData(
      primarySwatch: myColor,
      primaryColorDark: const Color(0xE7151533),
      primaryColorLight: Colors.white,
      fontFamily: 'Poppins',
      iconTheme: const IconThemeData(
        color: Color(0xE7791971),
      ),
    );

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'E-board',
      theme: darkModeEnabled ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
      // home: const TestingThis(),
    );
  }

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize();
  }
}

class TestingThis extends StatelessWidget {
  const TestingThis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(),
    );
  }
}
