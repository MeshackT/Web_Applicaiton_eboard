// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:levy/model/user.dart';
// import 'package:levy/screens/wrapper.dart';
// import 'package:levy/services/authService.dart';
// import 'package:provider/provider.dart';
//
// Future<void> main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<UserModel?>.value(
//       //call the stream to check changes
//       value: AuthService().user,
//       initialData: null,
//       catchError: (_,__) => null,
//       child: MaterialApp(
//         title: 'E-board',
//         theme: ThemeData(
//           primarySwatch: Colors.purple,
//         ),
//         debugShowCheckedModeBanner: false,
//         home: const Wrapper(),
//       ),
//     );
//   }
// }
