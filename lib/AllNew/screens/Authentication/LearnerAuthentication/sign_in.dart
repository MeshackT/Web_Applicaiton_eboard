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
                              height: MediaQuery.of(context).size.height / 5,
                              width: MediaQuery.of(context).size.width / 1.5,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Learner\nSign In",
                            textAlign: TextAlign.center,
                            style: textStyleText(context).copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColorLight),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 150),
                        color: Theme.of(context).primaryColorLight,
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
                                        child: SizedBox(
                                          height: 30,
                                          child: Text(
                                            "Click here!",
                                            style: textStyleText(context),
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
                                        label: Text(
                                          'Learner',
                                          style: textStyleText(context),
                                        ),
                                        hintText: "Learner"),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                      hintText: "Email",
                                      hintStyle: textStyleText(context),
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
                                    height: 15,
                                  ),
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                      hintText: "Password",
                                      hintStyle: textStyleText(context),
                                    ),
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
                                        child: Text(
                                          "Reset",
                                          style: textStyleText(context),
                                        ),
                                      )
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
                                              (value) => Navigator.push(
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
                                              snack(
                                                  "Failed to log in", context);
                                            });
                                          }
                                        },
                                        color: Theme.of(context).primaryColor,
                                        child: loading
                                            ? SpinKitChasingDots(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            : Text(
                                                "Sign In",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorLight),
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
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight),
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
        snack(error.toString(), context);
        setState(() {
          loading = false;
        });
      } else if (error == 'email-already-in-use') {
        snack(error.toString(), context);
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      if (error == "ERROR_INVALID_EMAIL") {
        snack(error.toString(), context);
      } else if (error == "ERROR_WRONG_PASSWORD") {
        snack(error.toString(), context);
      } else if (error == "ERROR_USER_NOT_FOUND") {
        snack(error.toString(), context);
      } else if (error == "ERROR_USER_DISABLED") {
        snack(error.toString(), context);
      } else if (error == "ERROR_TOO_MANY_REQUESTS") {
        snack(error.toString(), context);
      } else if (error == "ERROR_OPERATION_NOT_ALLOWED") {
        snack(error.toString(), context);
      } else {
        snack(error.toString(), context);
      }
    }

    //Navigator.current
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
  }
}
