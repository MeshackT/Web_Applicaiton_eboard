import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:levy/AllNew/screens/wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'E-board',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColorDark: Colors.purple,
        primaryColorLight: Colors.white,
        fontFamily: 'Poppins',
        iconTheme: IconThemeData(color: Colors.purple.shade400),
      ),
      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
      //home: const Home(),
    );
  }
}
