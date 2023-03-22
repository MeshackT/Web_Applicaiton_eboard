// import 'package:flutter/material.dart';
// import 'package:levy/model/user.dart';
// import 'package:levy/screens/home/home.dart';
// import 'package:levy/services/authService.dart';
// import 'package:provider/provider.dart';
// import 'Authentication/Authenticate.dart';
//
// class Wrapper extends StatelessWidget {
//   const Wrapper({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     AuthService authService = AuthService();
//     final user = Provider.of<UserModel?>(context);
//
//     // print this
//     authService.logInfor.i(user?.uid);
//     if(user==null){
//       return const Authenticate();
//     }else{
//       return const Home();
//     }
//   }
// }
//
