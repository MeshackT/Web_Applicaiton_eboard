import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:yueway/AllNew/screens/Notifications/local_notifications.dart';
import 'package:yueway/AllNew/screens/wrapper.dart';

// Import the generated file
import 'firebase_options.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //   options: const FirebaseOptions(
    //       apiKey: "AIzaSyALUsDsHtmbQrNOIuyl9Mr_zARl3rLGK34",
    //       authDomain: "ebase-3f858.firebaseapp.com",
    //       databaseURL: "https://ebase-3f858-default-rtdb.firebaseio.com",
    //       projectId: "ebase-3f858",
    //       storageBucket: "ebase-3f858.appspot.com",
    //       messagingSenderId: "231030944816",
    //       appId: "1:231030944816:web:07f5bbb2a7ddbdee26e9f5",
    //       measurementId: "G-EYXRE3102C",
    // ),
  );
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
      //home: const Home(),
    );
  }

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize();
  }
}
