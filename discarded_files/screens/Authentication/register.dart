// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import '../../services/authService.dart';
// import '../../shared/constants.dart';
//
// class Register extends StatefulWidget {
//   final Function toggleView;
//   const Register({Key? key, required this.toggleView}) : super(key: key);
//
//   @override
//   State<Register> createState() => _RegisterState();
// }
//
// class _RegisterState extends State<Register> {
//   AuthService authService = AuthService();
//   final _formKey = GlobalKey<FormState>();
//   //we access signing privileges using this class
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//
//   //textField state
//   String email = '';
//   String password = '';
//   String error = '';
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Register"),
//         elevation: 0,
//         backgroundColor: Colors.purple,
//         actions: [
//           Row(
//             children: [
//               IconButton(onPressed: () async{
//                   widget.toggleView();
//               },
//                 icon: const Icon(Icons.person,),),
//
//             ],
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: <Widget>[
//                     const SizedBox(height: 20,),
//                     TextFormField(
//                       decoration: textInputDecoration.copyWith(hintText: "Enter your email"),
//                       validator: (val){
//                         if(val!.isEmpty){
//                           return "enter an email";
//                         }else if(!val.contains("@")){
//                           return "enter a correct email";
//                         }
//                         return null;
//                       },
//                       onChanged: (val){
//                         setState(() {
//                           email = val;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 20,),
//                     TextFormField(
//                       decoration: textInputDecoration.copyWith(hintText: "Enter your password"),
//                       obscureText: true,
//                       validator: (val){
//                         if(val!.length < 6){
//                           return "enter a password greater than 5";
//                         }
//                         return null;
//                       },
//                       onChanged: (val){
//                         setState(() {
//                           password = val;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 20,),
//                     MaterialButton(
//                       onPressed: () async{
//                         //check if the form is validated
//                         if(_formKey.currentState!.validate()){
//                           dynamic resutl = await _auth
//                               .createUserWithEmailAndPassword(
//                               email: email, password: password);
//                           if(resutl == null){
//                             setState(() {
//                               error = 'Please enter ur valid email';
//                             });
//                           }
//                         }else{
//                           if (kDebugMode) {
//                             print("insert data as required");
//                           }
//
//                         }
//                       },
//                       color: Colors.purple,
//                       child: const Text("Register", style: TextStyle(color: Colors.white),),
//                     ),
//                     const SizedBox(height: 20,),
//                      Text(
//                       error,
//                       style: const TextStyle(
//                         color: Colors.red, fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//           ),
//         ),
//       ),
//     );
//   }
// }
