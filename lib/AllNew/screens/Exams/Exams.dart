import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:levy/AllNew/screens/home/selectTodDo.dart';

class Exams extends StatefulWidget {
  const Exams({Key? key}) : super(key: key);

  @override
  State<Exams> createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController examMark1 = TextEditingController();
  TextEditingController examMark2 = TextEditingController();


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
        title: const Text("Exam Marks"),
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
                const Text("Exam Marks", style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.purple,

                ),),
                const SizedBox(height: 25,),
                TextFormField(
                  decoration: const InputDecoration().copyWith(
                    label: const Text("Exam 1"),
                    hintText: "90",
                  ),
                  controller: examMark1,
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
                      examMark1.text = val;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration().copyWith(
                      label: const Text("Exam 2"), hintText: "90"),
                  controller: examMark2,
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
                      examMark2.text = val;
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
                      if (kDebugMode) {
                        print("insert data as required");
                      }
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