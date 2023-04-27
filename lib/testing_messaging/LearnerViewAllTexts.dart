import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../AllNew/model/ConnectionChecker.dart';
import '../AllNew/shared/constants.dart';

class LearnerViewAllTexts extends StatefulWidget {
  const LearnerViewAllTexts({Key? key}) : super(key: key);

  @override
  State<LearnerViewAllTexts> createState() => _LearnerViewAllTextsState();
}


class _LearnerViewAllTextsState extends State<LearnerViewAllTexts> {
  bool layoutIn = false;
  @override
  void initState() {
    super.initState();
    ConnectionChecker.checkTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 0.0),
      decoration: const BoxDecoration(
        //screen background color
        gradient: LinearGradient(
            colors: [Color(0x0fffffff), Color(0xE7791971)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("messagesWithTextOnly")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }  else if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.size <= 0) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      //screen background color
                      gradient: LinearGradient(
                          colors: [Color(0x0fffffff), Color(0xE7791971)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    child: Center(
                      child: Text(
                        "No data sent yet.",
                        style: textStyleText(context).copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SpinKitChasingDots(
                    color: Theme.of(context).primaryColor,
                  );
                } else {
                  var _documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: _documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = _documents[index];
                      String text = document.get("text");
                      String name = document.get("nameOfTeacher");
                      var dateAndTime = document.get("timestamp");
                      // String documentIDCurrent = document.id;

                      Timestamp timestamp = document.get("timestamp");
                      DateTime dateTime = timestamp.toDate();
                      // convert timestamp to DateTime
                      var formattedDateTime =
                          " ${dateTime.hour}:${dateTime.minute}";

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 5),
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  child: Text(
                                    name.toString()[0]??"",
                                    style: textStyleText(context).copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .primaryColorLight,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        
                                        children: [
                                          Text(
                                            name??"",
                                            style:
                                            textStyleText(context).copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                              Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30,
                                            height: 40,
                                            child: PopupMenuButton<int>(
                                              color: Colors.white,
                                              elevation: 5.0,
                                              itemBuilder: (context) => [
                                                PopupMenuItem<int>(
                                                  value: 0,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.share,
                                                        color: Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.7),
                                                      ),
                                                      const SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        "Share",
                                                        style: textStyleText(context)
                                                            .copyWith(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (item) => selectedItem(
                                                  context,
                                                  item,
                                                  name,
                                                  text),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            Utils.formattedDate(dateAndTime),
                                            style: textStyleText(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal,
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(.7),
                                                fontSize: 10),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            formattedDateTime,
                                            style: textStyleText(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.normal,
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(.7),
                                                fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Text(
                                text,
                                style: textStyleText(context),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  //TODO Show pop up button
  Future<void> selectedItem(
      BuildContext context, item, String nameOfSender,String text) async {
    switch (item) {
      case 0:
        try {
          if (text.isEmpty || text == "") {
            print("cant share");
            snack('There`s no url link found', context);
          } else {
            print("can share $text");
            await FlutterShare.share(
                title: "By $nameOfSender", text: text, chooserTitle: "By $nameOfSender");
          }
        } catch (e) {
          print(text);
          snack(e.toString(), context);
        }
        break;
    }
  }
}
