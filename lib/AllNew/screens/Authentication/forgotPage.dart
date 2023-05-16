import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yueway/main.dart';

import '../../main.dart';
import '../../model/ConnectionChecker.dart';
import '../../shared/constants.dart';
import 'Authenticate.dart';

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
          child: SingleChildScrollView(
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
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50, bottom: 50),
                          child: Center(
                            child: Text(
                              "Facilitator\nReset Password",
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
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            color: Theme.of(context)
                                                .primaryColorLight),
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
                                        await forgotPassword()
                                            .then(
                                              (value) => snack(
                                                  "Link sent to your email",
                                                  context),
                                            )
                                            .whenComplete(() => Navigator.of(
                                                    context)
                                                .pushReplacement(MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Authenticate())));
                                      } else {
                                        snack("enter your email", context);
                                      }
                                    },
                                    color: Theme.of(context).primaryColor,
                                    child: loading
                                        ? SpinKitChasingDots(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          )
                                        : Text(
                                            "Reset ",
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



  Future<void> forgotPassword() async {
    //set this state after I press the button
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      snack(e.toString(), context);
    }

    //Navigator.current
    navigatorKey.currentState!.popUntil((route) {
      return route.isFirst;
    });
    //set this state after I press the button
    setState(() {
      loading = false;
    });
  }
}
