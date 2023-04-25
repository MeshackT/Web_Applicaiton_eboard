// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AccountList extends StatefulWidget {
//   @override
//   _AccountListState createState() => _AccountListState();
// }
//
// class _AccountListState extends State<AccountList> {
//   List<User> _accounts = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _getAccounts();
//   }
//
//
//
//
//   Future<void> _getAccounts() async {
//     try {
//       List<UserRecord> userRecords = (await FirebaseAuth.instance.users()).toList();
//       List<User> accounts = userRecords.map((userRecord) => userRecord.toUser()).toList();
//       setState(() {
//         _accounts = accounts;
//       });
//     } catch (e) {
//       print('Error retrieving accounts: $e');
//     }
//   }
//
//   Future<void> _deleteAccount(User account) async {
//     try {
//       await FirebaseAuth.instance.deletecurUser(account.uid);
//       setState(() {
//         _accounts.remove(account);
//       });
//     } catch (e) {
//       print('Error deleting account: $e');
//     }
//   }
//
//   Future<void> _disableAccount(User account) async {
//     try {
//       await FirebaseAuth.instance.updateUser(account.uid, disabled: true);
//       setState(() {
//         account = account.copyWith(disabled: true, displayName: '', photoURL: '', phoneNumber: '');
//       });
//     } catch (e) {
//       print('Error disabling account: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Account List'),
//       ),
//       body: ListView.builder(
//         itemCount: _accounts.length,
//         itemBuilder: (context, index) {
//           final account = _accounts[index];
//           return ListTile(
//             title: Text(account.email),
//             subtitle: account.disabled ? Text('Disabled') : null,
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () => _deleteAccount(account),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.block),
//                   onPressed: () => _disableAccount(account),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class User {
//   final String uid;
//   final String email;
//   final String displayName;
//   final String photoURL;
//   final String phoneNumber;
//   final bool disabled;
//
//   const User({
//     required this.uid,
//     required this.email,
//     required this.displayName,
//     required this.photoURL,
//     required this.phoneNumber,
//     this.disabled = false,
//   });
//
//   User copyWith({
//     required String displayName,
//     required String photoURL,
//     required String phoneNumber,
//     required bool disabled,
//   }) {
//     return User(
//       uid: uid,
//       email: email,
//       displayName: displayName ?? this.displayName,
//       photoURL: photoURL ?? this.photoURL,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       disabled: disabled ?? this.disabled,
//     );
//   }
// }
