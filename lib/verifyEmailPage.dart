import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/screens/Authentication/Authenticate.dart';
import 'package:levy/AllNew/screens/home/home.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool loading = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const Home()
        : Scaffold(
            body: Container(
              color: Theme.of(context).primaryColorLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verification email has been sent\n to your account.",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(70),
                        topLeft: Radius.circular(70),
                        bottomRight: Radius.circular(70),
                        bottomLeft: Radius.circular(70),
                      ),
                      child: MaterialButton(
                        height: 80,
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          sendVerificationEmail();
                          setState(() {
                            loading = false;
                          });
                        },
                        color: Theme.of(context).primaryColorDark,
                        child: loading
                            ? SpinKitChasingDots(
                                color: Theme.of(context).primaryColorLight,
                              )
                            : Text(
                                "Verify",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Authenticate()));

                      setState(() {
                        loading = false;
                      });
                    },
                    color: Theme.of(context).primaryColorLight,
                    child: loading
                        ? SpinKitChasingDots(
                            color: Theme.of(context).primaryColorDark,
                          )
                        : Text(
                            "Wrong Account?",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark),
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}
