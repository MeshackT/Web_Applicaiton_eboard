import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TestingListOfItems extends StatefulWidget {
  const TestingListOfItems({Key? key}) : super(key: key);

  @override
  State<TestingListOfItems> createState() => _TestingListOfItemsState();
}

class _TestingListOfItemsState extends State<TestingListOfItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing List of Items"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('learnersData')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitChasingDots(
                        color: Theme
                            .of(context)
                            .primaryColor,
                      ),
                    );
                  }

                  final documents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final myArray =
                      documents[index]['subjects'] as List<dynamic>;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: myArray.length,
                        itemBuilder: (BuildContext context, int index) {
                          //final item = myArray[index];

                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              for (var item in myArray) ...[
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(280),
                                    topRight: Radius.circular(0),
                                    topLeft: Radius.circular(280),
                                  ),
                                  child: Container(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    child: ListTile(
                                      title: Text(
                                        item,
                                        style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .primaryColorLight),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ]
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
