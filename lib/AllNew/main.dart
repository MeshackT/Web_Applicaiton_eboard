import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yueway/AllNew/screens/wrapper.dart';

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
    Future<void> getPermission() async {
      await Permission.photos.request();
      await Permission.contacts.request();
      await Permission.storage.request();
      await Permission.notification.request();
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
        Permission.phone,
        Permission.storage,
        Permission.notification,
        //add more permission to request here.
      ].request();
      if (statuses[Permission.photos]!.isDenied) {
        //check each permission status after.
        //showToast("Permission Denied");
        print("Permission Denied");
      } else if (statuses[Permission.phone]!.isDenied) {
        //check each permission status after.
        //showToast("Permission Denied");
        print("Permission Denied");
      }else if (statuses[Permission.storage]!.isDenied) {
        //check each permission status after.
        //showToast("Permission Denied");
        print("Permission Denied");
      } else if (statuses[Permission.notification]!.isDenied) {
        //check each permission status after.
        //showToast("Permission Denied");
        print("Permission Denied");
      }else if (statuses[Permission.camera]!.isDenied) {
        //check each permission status after.
        //showToast("Permission Denied");
        print("Permission Denied");
      }else {
        //showToast("Permission Granted");
        print("Permission Granted");
      }
    }


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
}
