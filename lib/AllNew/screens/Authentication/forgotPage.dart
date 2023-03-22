import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/screens/Authentication/Authenticate.dart';

import '../../main.dart';
import '../../shared/constants.dart';

class Forgot extends StatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  String email = "";
  bool loading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topRight: Radius.circular(280),
                      topLeft: Radius.circular(280),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width / 1.5,
                      color: Colors.purple,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 50, bottom: 50),
                        child: Center(
                          child: Text(
                            "Facilitator\nReset Password",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 30),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Email"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "enter an email";
                                } else if (!val.contains("@")) {
                                  return "enter a correct email";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Forgot password?"),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Authenticate(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(color: Colors.purple),
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(70),
                                bottomRight: Radius.circular(70),
                              ),
                              child: SizedBox(
                                width: 120,
                                child: MaterialButton(
                                  height: 60,
                                  onPressed: () async {
                                    //check if the form is validated
                                    if (formKey.currentState!.validate()) {
                                      forgotPassword().then((value) =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'An email has been sent to your account.'),
                                              duration: Duration(seconds: 3),
                                            ),
                                          ));
                                    } else {
                                      print("insert data as required");
                                      // Utils.showSnackBar("Enter log in details");
                                      setState(() {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('Enter your email'),
                                          duration: Duration(seconds: 2),
                                        ));
                                      });
                                    }
                                  },
                                  color: Colors.purple,
                                  child: loading
                                      ? SpinKitChasingDots(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        )
                                      : const Text(
                                          "Reset ",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snack(
      String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message.toString()),
      duration: const Duration(seconds: 4),
    ));
  }

  Future forgotPassword() async {
    try {
      //set this state after I press the button
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      //set this state after I press the button
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      snack(e.toString());
    }

    //Navigator.current
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
  }
}
