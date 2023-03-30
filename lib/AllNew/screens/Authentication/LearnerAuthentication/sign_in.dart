import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/screens/Authentication/Authenticate.dart';
import 'package:levy/AllNew/screens/Authentication/LearnerAuthentication/forgotPage.dart';
import 'package:levy/AllNew/shared/loading.dart';

import '../../../main.dart';
import '../../../shared/constants.dart';
import '../../home/learnersHome.dart';

class LearnerSignIn extends StatefulWidget {
  final Function toggleView;

  const LearnerSignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<LearnerSignIn> createState() => _LearnerSignInState();
}

class _LearnerSignInState extends State<LearnerSignIn> {
  // AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  //we access signing privileges using this class
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  //textField state
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor
              .withOpacity(1),
          content: Text(
            'Tap back again to leave the application',
            style: TextStyle(color: Theme
                .of(context)
                .primaryColorLight),
            textAlign: TextAlign.center,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        topRight: Radius.circular(280),
                        topLeft: Radius.circular(280),
                      ),
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 5,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 1.5,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text(
                      "Learner\nSign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 150),
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(
                                    height: 30,
                                    child:
                                    Text("Are you a facilitator?")),
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
                                  child: const SizedBox(
                                    height: 30,
                                    child: Text(
                                      "Click here!",
                                      style:
                                      TextStyle(color: Colors.purple),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              enabled: false,
                              decoration: textInputDecoration.copyWith(
                                  label: const Text(
                                    'Learner',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 1),
                                  ),
                                  hintText: "Learner"),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                hintText: "Email",

                              ),
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
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Password"),
                              obscureText: true,
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "enter a password greater than 5";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
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
                                          const LearnerForgot(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Reset",
                                      style:
                                      TextStyle(color: Colors.purple),
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(70),
                                topLeft: Radius.circular(70),
                              ),
                              child: SizedBox(
                                width: 120,
                                child: MaterialButton(
                                  height: 60,
                                  onPressed: () async {
                                    //check if the form is validated
                                    if (_formKey.currentState!
                                        .validate()) {
                                      signIn().then(
                                            (value) =>
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                const LearnerHome(),
                                              ),
                                            ),
                                      );
                                    } else {
                                      print("insert data as required");
                                      // Utils.showSnackBar("Enter log in details");
                                      setState(() {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('Enter details'),
                                          duration: Duration(seconds: 1),
                                        ));
                                      });
                                    }
                                  },
                                  color: Colors.purple,
                                  child: loading
                                      ? const SpinKitChasingDots(
                                    color: Colors.white,
                                  )
                                      : const Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
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
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                  color: Colors.purple,
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
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
      content: Text(
        message.toString(),
        style: TextStyle(
          color: Theme
              .of(context)
              .primaryColorLight,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: const Duration(seconds: 4),
    ));
  }

  Future signIn() async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim().toLowerCase(), password: password.trim());
      //set this state after I press the button
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snack(error.toString());
        setState(() {
          loading = false;
        });
      } else if (error == 'email-already-in-use') {
        snack(error.toString());
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      if (error == "ERROR_INVALID_EMAIL") {
        snack(error.toString());
      } else if (error == "ERROR_WRONG_PASSWORD") {
        snack(error.toString());
      } else if (error == "ERROR_USER_NOT_FOUND") {
        snack(error.toString());
      } else if (error == "ERROR_USER_DISABLED") {
        snack(error.toString());
      } else if (error == "ERROR_TOO_MANY_REQUESTS") {
        snack(error.toString());
      } else if (error == "ERROR_OPERATION_NOT_ALLOWED") {
        snack(error.toString());
      } else {
        snack(error.toString());
      }
    }

    //Navigator.current
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
  }
}
