// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:levy/AllNew/screens/Authentication/Authenticate.dart';
//
// import 'AllNew/screens/home/home.dart';
// import 'AllNew/screens/home/learnersHome.dart';
//
// class RoleChecker extends StatelessWidget {
//   final User user;
//
//   const RoleChecker({Key? key, required this.user}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('learnersData')
//           .doc(user.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final DocumentSnapshot userSnapshot = snapshot.data!;
//           final String userRole = userSnapshot['role'];
//           if (userRole == 'student') {
//             // User is a student, navigate to the student screen
//             return const LearnerHome();
//           } else if (userRole == 'teacher') {
//             // User is a teacher, navigate to the teacher screen
//             return const Home();
//           } else {
//             // User has an invalid role, log them out and navigate to the login screen
//             FirebaseAuth.instance.signOut();
//             return const Authenticate();
//           }
//         } else {
//           // Show a loading indicator while the user data is being fetched
//           return SpinKitChasingDots(
//             color: Theme.of(context).primaryColor,
//           );
//         }
//       },
//     );
//   }
// }
