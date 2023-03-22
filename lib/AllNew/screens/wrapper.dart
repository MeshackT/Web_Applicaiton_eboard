import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:levy/verifyEmailPage.dart';

import 'Authentication/Authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  static const routeName = '/wrapper';

  @override
  Widget build(BuildContext context) {
    // print this
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else if (snapshot.hasError) {
            return const Authenticate();
          } else {
            return const Authenticate();
          }
        });
  }
}
