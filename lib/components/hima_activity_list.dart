import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef Fn = Function({required String himaActivities});

Future<void> himaActivityList({
  required BuildContext context,
  // required Null Function({required DateTime date}) handler,
  final String? uid,
  required Fn handler,
}) async {
  String newHimaActivity = "";
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            )),
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          // controller: hourController,
                          decoration: const InputDecoration(
                            labelText: '何したい？',
                          ),
                          onChanged: (value) {
                            newHimaActivity = value;
                          },
                        ),
                        ElevatedButton(
                          onPressed: newHimaActivity == ""
                              ? null
                              : () async {
                                  final snapshot = await FirebaseFirestore
                                      .instance
                                      .collection("users")
                                      .where("id", isEqualTo: uid)
                                      .get();
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(snapshot.docs[0].id)
                                      .collection("himaActivities")
                                      .add({
                                    'content': newHimaActivity,
                                  });
                                },
                          child: Text('選択肢に追加'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      minimumSize:
                          MaterialStateProperty.all(const Size(150, 45)),
                    ),
                    child: const Text(
                      '閉じる',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepOrangeAccent),
                      minimumSize:
                          MaterialStateProperty.all(const Size(150, 45)),
                    ),
                    child: const Text(
                      '決定',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      handler(himaActivities: newHimaActivity);
                      Navigator.of(context).pop();
                      
                      
                      
                      
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
