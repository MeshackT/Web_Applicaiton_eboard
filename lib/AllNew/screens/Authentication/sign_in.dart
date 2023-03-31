import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/screens/Authentication/LearnerAuthentication/Authenticate.dart';
import 'package:levy/AllNew/screens/Authentication/forgotPage.dart';
import 'package:levy/AllNew/screens/home/home.dart';
import 'package:levy/AllNew/shared/loading.dart';

import '../../main.dart';
import '../../shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  //we access signing previlages using this class
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool passwordVisible = true;

  //textField state
  String email = '';
  String password = '';
  String error = '';
  String codeUnit = '';
  bool loading = false;
  String role = "teacher";
  String code = '';
  String codePassword = "WMPSST";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.white,
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
                            "Facilitator\nSign In",
                            textAlign: TextAlign.center,
                            style: textStyleText(context).copyWith(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
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
                                          child: Text("Are you a learner?")),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LearnerAuthenticate(),
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            height: 30,
                                            child: Text(
                                              "Click here!",
                                              style: textStyleText(context),
                                            ),
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    enabled: false,
                                    decoration: textInputDecoration.copyWith(
                                      hintText: "Teacher",
                                      hintStyle: textStyleText(context),
                                    ),
                                    validator: (val) {
                                      setState(() {
                                        val = role;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        codeUnit = role;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                          icon: passwordVisible
                                              ? Icon(
                                                  Icons.visibility,
                                                  color: IconTheme.of(context)
                                                      .color,
                                                )
                                              : Icon(
                                                  Icons.lock,
                                                  color: IconTheme.of(context)
                                                      .color,
                                                ),
                                        ),
                                        label: Text(
                                          'Code',
                                          style: textStyleText(context),
                                        ),
                                        hintText: "Insert Code"),
                                    obscureText: passwordVisible,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "enter a code";
                                      } else if (codePassword != code) {
                                        return "Incorrect code";
                                      }
                                      return null;
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        code = val;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
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
                                    height: 20,
                                  ),
                                  TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                        icon: passwordVisible
                                            ? Icon(
                                                Icons.visibility,
                                                color:
                                                    IconTheme.of(context).color,
                                              )
                                            : Icon(
                                                Icons.lock,
                                                color:
                                                    IconTheme.of(context).color,
                                              ),
                                      ),
                                      hintText: "Password",
                                      hintStyle: textStyleText(context),
                                    ),
                                    obscureText: passwordVisible,
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
                                      const SizedBox(
                                          height: 30,
                                          child: Text("Forgot password?")),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Forgot(),
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            height: 30,
                                            child: Text(
                                              "Reset",
                                              style: textStyleText(context),
                                            ),
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
                                            signIn();
                                          } else {
                                            setState(() {
                                              snack(
                                                  "Failed to Sign In", context);
                                            });
                                          }
                                        },
                                        color: Theme.of(context).primaryColor,
                                        child: loading
                                            ? SpinKitChasingDots(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
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
                                          style: textStyleText(context)
                                              .copyWith(
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

  //Works perfect
  Future signIn() async {
    try {
      //set this state after I press the button
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.trim().toLowerCase(), password: password.trim())
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            ),
          );
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      //if user is not found then display this msg
      if (e.code == 'user-not-found') {
        setState(() {
          snack("Email not found", context);
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          loading = false;
          snack('Wrong password', context);
        });
      }

      //Navigator.current
      navigatorKey.currentState!.popUntil((route) {
        return route.isFirst;
      });
    }
  }
}
