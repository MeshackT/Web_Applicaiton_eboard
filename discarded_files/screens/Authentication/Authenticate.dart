// import 'package:flutter/material.dart';
// import 'package:levy/screens/Authentication/sign_in.dart';
// import 'package:levy/services/authService.dart';
// import 'register.dart';
//
// class Authenticate extends StatefulWidget {
//   const Authenticate({Key? key}) : super(key: key);
//
//   @override
//   State<Authenticate> createState() => _AuthenticateState();
// }
//
// class _AuthenticateState extends State<Authenticate> {
//   AuthService authService = AuthService();
//
//   bool showSignIn = true;
//
//   void toggleView(){
//     setState(() {
//       //get the reverse of showSign In
//       showSignIn = !showSignIn;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if(showSignIn == true){
//       return SignIn(toggleView: toggleView);
//     }else{
//       return Register(toggleView: toggleView);
//     }
//   }
// }
