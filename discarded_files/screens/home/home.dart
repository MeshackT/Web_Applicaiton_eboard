// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:levy/screens/Authentication/Authenticate.dart';
// import 'package:levy/services/authService.dart';
// import 'package:levy/shared/loading.dart';
//
// import '../Authentication/sign_in.dart';
//
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   AuthService authService = AuthService();
//   @override
//   Widget build(BuildContext context) {
//
//     final Stream<QuerySnapshot> collectionReference =
//     FirebaseFirestore.instance.collection('teachersDetails').snapshots();
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: collectionReference,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text("Loading");
//         }
//
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text("Home page"),
//             elevation: 0,
//             actions: [
//               Row(
//                 children: [
//                   IconButton(onPressed: () async{
//                     await authService.signOut().then((value) =>
//                     const CircularProgressIndicator()).whenComplete(() =>
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => Authenticate())
//                         ),
//                     );
//
//                   },
//                     icon: const Icon(Icons.logout,),),
//
//                 ],
//               )
//             ],
//           ),
//           body: ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//               return ListTile(
//                 title: Text(data['nameSurname'], style: TextStyle(color: Colors.purple),),
//                 subtitle: Text(data['subject']),
//                 trailing: Text(data['uid']),
//               );
//             }).toList(),
//           ),
//         );a
//
//
//           //
//
//       },
//     );
//   }
// }
//
//
//
// /*
// *
// * */