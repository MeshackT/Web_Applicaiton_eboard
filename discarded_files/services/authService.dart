// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:levy/services/databaseService.dart';
// import 'package:logger/logger.dart';
// import 'package:levy/model/user.dart';
//
// class AuthService{
//
//   //we access signing privilages using this class
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // create a user object using firebaseUser
//   // <firebaseUser> was changed to <User>
//   // get user ID from database
//   UserModel? userFromFirebaseUser(User user) {
//     return UserModel(uid: user.uid);
//
//   }
//
//   //check if the user signed in or not
//   Stream<UserModel?> get user{
//     return  _auth.authStateChanges()
//         .map((User? user) => userFromFirebaseUser(user!));
//   }
//
//
//   //sign in anonymously
//   Future signInAnonymous() async{
//     try {
//       //<AuthResult> was changed to User <credentials>
//       final userCredential = await _auth.signInAnonymously();
//
//       //get an instance of a user
//       User? user = userCredential.user;
//           if (kDebugMode) {
//             print("Signed in with temporary account.");
//           }
//     return userFromFirebaseUser(user!);
//
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case "operation-not-allowed":
//           if (kDebugMode) {
//             print("Anonymous auth hasn't been enabled for this project.");
//           }
//           break;
//         default:
//           if (kDebugMode) {
//             print("Unknown error.");
//           }
//       }
//     }
//     return null;
//   }
//
//   //Register with email and password
//   Future registerWithEmailAndPassword(String email, String password) async{
//     try{
//       //get the method tpo sign into firebase register
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       // <firebaseUser> was changed to <User>
//       User? user= userCredential.user;
//
//       //create a new document for the user with uid
//       await DatabaseService(uid: user!.uid).updateUserData("12", "Mathematics","Meshack");
//
//       return userFromFirebaseUser(user);
//
//     }catch(e){
//       print(e.toString());
//       return null;
//     }
//
//     return null;
//   }
//
//   //Sign with email and password
//   Future signInWithEmailAndPassword(String email, String password) async{
//     try{
//       //get the method tpo sign into firebase register
//       final userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       // <firebaseUser> was changed to <User>
//       User? user= userCredential.user;
//
//       return userFromFirebaseUser(user!);
//
//     }catch(e){
//       print(e.toString());
//       return null;
//     }
//
//     return null;
//   }
//
//
//   Future signOut() async{
//     try {
//       await _auth.signOut();
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case "operation-not-allowed":
//           if (kDebugMode) {
//             print("Anonymous auth hasn't been enabled for this project.");
//           }
//           break;
//         default:
//           if (kDebugMode) {
//             print("Unknown error.");
//           }
//       }
//     }
//     return null;
//
//   }
// //reveal information
//   Logger logInfor = Logger(
//       printer: PrettyPrinter(
//         colors: true,
//       )
//   );
// }