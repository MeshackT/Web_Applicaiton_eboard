// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:levy/shared/loading.dart';
//
// import '../../services/authService.dart';
// import '../../shared/constants.dart';
//
// class SignIn extends StatefulWidget {
//   final Function toggleView;
//
//   const SignIn({Key? key, required this.toggleView}) : super(key: key);
//
//   @override
//   State<SignIn> createState() => _SignInState();
// }
//
// class _SignInState extends State<SignIn> {
//
//   AuthService authService = AuthService();
//   final _formKey = GlobalKey<FormState>();
//   //we access signing previlages using this class
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool isLoading = false;
//
//   //textField state
//   String email = '';
//   String password = '';
//   String error = '';
//
//
//   @override
//   Widget build(BuildContext context) {
//     return isLoading ? const Loading() : Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign In"),
//         elevation: 0,
//         backgroundColor: Colors.purple,
//         actions: [
//           Row(
//             children: [
//               IconButton(onPressed: () async{
//                 widget.toggleView();
//               },
//                 icon: const Icon(Icons.person,),),
//
//             ],
//           )
//         ],
//       ),
//       body: SizedBox(
//         child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: <Widget>[
//                   const SizedBox(height: 20,),
//                   TextFormField(
//                     decoration: textInputDecoration.copyWith(hintText: "Email"),
//                     validator: (val){
//                       if(val!.isEmpty){
//                         return "enter an email";
//                       }else if(!val.contains("@")){
//                         return "enter a correct email";
//                       }
//                       return null;
//                     },
//                     onChanged: (val){
//                       setState(() {
//                         email = val;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20,),
//                   TextFormField(
//                     decoration: textInputDecoration.copyWith(hintText: "Password"),
//                     obscureText: true,
//                     validator: (val){
//                       if(val!.length < 6){
//                         return "enter a password greater than 5";
//                       }
//                       return null;
//                     },
//                     onChanged: (val){
//                       setState(() {
//                         password = val;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20,),
//                   MaterialButton(
//                     onPressed: () async{
//                       //check if the form is validated
//                       if(_formKey.currentState!.validate()){
//                         // dynamic result =
//                         await _auth.signInWithEmailAndPassword(
//                             email: email, password: password);
//
//                         // if(result == null){
//                         //   setState(() {
//                         //     error = "User doesn't exist";
//                         //     isLoading = false;
//                         //   });
//                         // }
//                       }else{
//                         print("insert data as required");
//                         Fluttertoast.showToast(msg: error, backgroundColor: Colors.purple, textColor: Colors.white);
//                       }
//                     },
//                     color: Colors.purple,
//                     child: const Text("Sign In", style: TextStyle(color: Colors.white),),
//                   ),
//
//                   Text(
//                     error,
//                     style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//         ),
//       ),
//     );
//   }
// }
