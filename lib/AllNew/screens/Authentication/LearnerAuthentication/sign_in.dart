import 'package:Eboard/main.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

import '../../../model/ConnectionChecker.dart';
import '../../../shared/constants.dart';
import '../../home/learnersHome.dart';
import '../Authenticate.dart';
import 'forgotPage.dart';

Logger logger = Logger(printer: PrettyPrinter(colors: true));

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
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(top: 0.0),
            decoration: const BoxDecoration(
              //screen background color
              gradient: LinearGradient(
                  colors: [Color(0x0fffffff), Color(0xE7791971)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          topRight: Radius.circular(300),
                          topLeft: Radius.circular(300),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context).primaryColor,
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
                                      color:
                                          Theme.of(context).primaryColorLight),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
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
                              SizedBox(
                                  height: 30,
                                  child: Text(
                                    "Are you a facilitator?",
                                    style: textStyleText(context).copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w700),
                                  )),
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
                                    style: textStyleText(context).copyWith(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Learner',
                                style: textStyleText(context)
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
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
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: passwordVisible
                                    ? Icon(
                                        Icons.visibility,
                                        color: IconTheme.of(context).color,
                                      )
                                    : Icon(
                                        Icons.lock,
                                        color: IconTheme.of(context).color,
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
                              Text(
                                "Forgot password?",
                                style: textStyleText(context).copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.w700),
                              ),
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
                                  style: textStyleText(context).copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(100),
                              topLeft: Radius.circular(100),
                            ),
                            child: SizedBox(
                              width: 120,
                              child: MaterialButton(
                                height: 60,
                                onPressed: () async {
                                  //check if the form is validated
                                  if (_formKey.currentState!.validate()) {
                                    signIn();
                                  } else {
                                    print("insert data as required");
                                    // Utils.showSnackBar("Enter log in details");
                                    setState(() {
                                      snack("Failed to log in", context);
                                    });
                                  }
                                },
                                color: Theme.of(context).primaryColor,
                                child: loading
                                    ? SpinKitChasingDots(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      )
                                    : Text(
                                        "Sign In",
                                        style: textStyleText(context).copyWith(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            fontWeight: FontWeight.w700),
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
                                  style: textStyleText(context).copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    setState(() {
      loading = true;
    });
    final navContext = Navigator.of(context);
    try {
      bool userExists = false;

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password.trim(),
      );
      userExists = userCredential.user != null;
      //if user is not null, navigate
      if (userExists != null) {
        //print(userExists);
        navContext.pushReplacement(
            MaterialPageRoute(builder: (context) => const LearnerHome()));
        //else show a snack
      } else if (userExists == null) {
        snack("Email doesn't exist.", context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snack("Email doesn't exist", context);
        setState(() {
          loading = false;
        });
        return;
      } else if (e.code == 'wrong-password') {
        snack("Wrong password provided", context);
        setState(() {
          loading = false;
        });
        return;
      } else {
        logger.i(error);
      }
      setState(() {
        loading = false;
      });
    } catch (error) {
      logger.i(error);
      // Handle other types of errors
      switch (error) {
        case 'ERROR_INVALID_EMAIL':
        case 'ERROR_WRONG_PASSWORD':
        case 'ERROR_USER_DISABLED':
        case 'ERROR_TOO_MANY_REQUESTS':
        case 'ERROR_OPERATION_NOT_ALLOWED':
          snack(error.toString(), context);
          break;
        default:
          snack('An unknown error occurred', context);
          break;
      }

      setState(() {
        loading = false;
      });

      // Clear the login screen stack from the navigator
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }
}
