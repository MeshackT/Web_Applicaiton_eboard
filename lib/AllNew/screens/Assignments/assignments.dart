import 'package:flutter/material.dart';
import 'package:levy/AllNew/screens/home/selectTodDo.dart';

import '../home/home.dart';

class Assignments extends StatefulWidget {
  const Assignments({Key? key}) : super(key: key);

  @override
  State<Assignments> createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController assignMark1 = TextEditingController();
  TextEditingController assignMark2 = TextEditingController();
  TextEditingController assignMark3 = TextEditingController();
  TextEditingController assignMark4 = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                navigate(context);
              },
              icon: const Icon(Icons.arrow_back),),
          ],
        ),
        title: Text("Test Marks"),
        titleSpacing: 2,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 25,),
                const Text("Assignment Marks", style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.purple,

                ),),
                const SizedBox(height: 25,),
                TextFormField(
                  decoration: const InputDecoration().copyWith(
                    label: const Text("Assignment 1"),
                    hintText: "90",
                  ),
                  controller: assignMark1,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "No mark entered or else enter zero";
                    } else if (val.length > 100) {
                      return "Enter a number from 0 to 100";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      assignMark1.text = val;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration().copyWith(
                      label: const Text("Assignment 2"), hintText: "90"),
                  controller: assignMark2,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "No mark entered or else enter zero";
                    } else if (val.length > 100) {
                      return "Enter a number from 0 to 100";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      assignMark2.text = val;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration().copyWith(
                    label: const Text("Assignment 3"),
                    hintText: "90",
                  ),
                  controller: assignMark3,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "No mark entered else enter zero";
                    } else if (val.length > 100) {
                      return "Enter a number from 0 to 100";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      assignMark3.text = val;
                    });
                  },

                ),
                TextFormField(
                  decoration: const InputDecoration().copyWith(
                      label: const Text("Assignment 4"), hintText: "90"),
                  controller: assignMark4,
                  keyboardType: const TextInputType.numberWithOptions(),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "No mark entered else enter zero";
                    } else if (val.length > 100) {
                      return "Enter a number from 0 to 100";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      assignMark4.text = val;
                    });
                  },
                ),
                const SizedBox(height: 25,),
                MaterialButton(
                  onPressed: () async {
                    //check if the form is validated
                    if (_formKey.currentState!.validate()) {
                      //signIn();
                    } else {
                      print("insert data as required");
                      // Utils.showSnackBar("Enter log in details");
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Enter details'),
                          duration: const Duration(seconds: 1),
                          action: SnackBarAction(
                            label: 'ACTION',
                            onPressed: () {

                            },
                          ),
                        ));
                      });
                    }
                  },
                  color: Colors.purple,
                  child: const Text(
                    "Save", style: TextStyle(color: Colors.white),),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Navigate to the previous page
  Future navigate(BuildContext context){
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context)=> const Select(),),);
  }