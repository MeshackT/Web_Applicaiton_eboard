import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:yueway/AllNew/screens/Notifications/local_notifications.dart';
import 'package:yueway/AllNew/screens/wrapper.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalNotificationService localNotificationService = LocalNotificationService();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    bool darkModeEnabled = false; // initial state of the switch

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
    localNotificationService.getPermission();

    // FirebaseMessaging.instance.getInitialMessage().then((event) {
    //   if (event != null) {
    //     final routeFromMessage = event.data["AllToSee"];
    //     logger.e("THis is the route => $routeFromMessage");
    //     Navigator.of(context).pushReplacement(routeFromMessage);
    //     print("${event.notification!.title} ${event.notification!.body}");
    //   }
    //
    // });
  }
}
