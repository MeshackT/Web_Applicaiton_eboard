import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:levy/AllNew/screens/Authentication/Authenticate.dart';

import '../../../main.dart';
import '../../../shared/constants.dart';

class LearnerForgot extends StatefulWidget {
  const LearnerForgot({Key? key}) : super(key: key);

  @override
  State<LearnerForgot> createState() => _LearnerForgotState();
}

class _LearnerForgotState extends State<LearnerForgot> {
  String email = "";
  final formKey = GlobalKey<FormState>();
  bool loading = false;

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
        child: SingleChildScrollView(
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
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50, bottom: 50),
                          child: Center(
                            child: Text(
                              "Learner\nReset Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
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
                                  hintText: "Email",
                                  hintStyle: textStyleText(context),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
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
                                                const Authenticate(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        height: 30,
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              letterSpacing: 1,
                                              color: Theme.of(context)
                                                  .primaryColorLight),
                                        ),
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
                                        forgotPassword().then((value) => snack(
                                            "Link sent to your mail", context));
                                      } else {
                                        print("insert data as required");
                                        // Utils.showSnackBar("Enter log in details");
                                        setState(() {
                                          snack("Enter your email", context);
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
                                            "Reset",
                                            style: textStyleText(context)
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColorLight),
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
      ),
    );
  }

  Future forgotPassword() async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading == false;
      });
      snack(e.toString(), context);
    }

    //Navigator.current
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
  }
}
