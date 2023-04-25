import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'AllNew/model/ConnectionChecker.dart';
import 'AllNew/screens/Authentication/Authenticate.dart';
import 'AllNew/screens/home/home.dart';

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
    ConnectionChecker.checkTimer();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      //VerificationModel.sendVerificationEmail();


      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) {
          checkEmailVerified();
          //VerificationModel.checkEmailVerified();
          // setState(() {
          //   isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
          // });
          if (isEmailVerified) {
            timer?.cancel();
          }
          checkEmailVerified();
        }
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();

      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
      if (isEmailVerified) {
        timer?.cancel();
      }
    } catch (e) {
      Fluttertoast.showToast(
          backgroundColor: Theme.of(context).primaryColor,
          msg: "Email not verified");
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      logger.i(e.toString());
      //snack(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const Home()
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  color: Theme.of(context).primaryColorLight,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Verification email has been sent to your account. Click Verify if you did not receive the link.",
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
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
                              try {
                                await sendVerificationEmail();
                                //await VerificationModel.sendVerificationEmail();
                                Fluttertoast.showToast(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    msg: "Sent Email");
                              } catch (e) {
                                Fluttertoast.showToast(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    msg: "Failed to send the email");
                              }
                              setState(() {
                                loading = false;
                              });
                            },
                            color: Theme.of(context).primaryColorDark,
                            child: loading
                                ? SpinKitChasingDots(
                                    color: Theme.of(context).primaryColorLight,
                              size: 12,
                            )
                                : Text(
                                    "Verify",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight),
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
                          final navigatorContext = Navigator.of(context);
                          try {
                            await FirebaseAuth.instance.signOut();
                          } on Exception catch (e) {
                            // TODO
                            logger.e(e);
                          }
                          setState(() {
                            loading = true;
                          });
                          navigatorContext.pushReplacement(MaterialPageRoute(
                              builder: (context) => const Authenticate()));
                        },
                        color: Theme.of(context).primaryColorLight,
                        child: loading
                            ? SpinKitChasingDots(
                                color: Theme.of(context).primaryColor,
                          size: 13,
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
              ),
            ),
          );
  }
}
