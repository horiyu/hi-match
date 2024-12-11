import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef Fn = Function({required String himaActivities});

Future<void> himaActivityList({
  required BuildContext context,
  final String? uid,
  required Fn handler,
}) async {
  String newHimaActivity = "";
  final textController = TextEditingController();
  final isButtonEnabled = ValueNotifier<bool>(false);

  final tags = [
    'ビール',
    'ワイン',
    '日本酒',
    '焼酎',
    'ウィスキー',
    'ジン',
    'ウォッカ',
    '紹興酒',
    'マッコリ',
    'カクテル',
    '果実酒',
  ];
  var selectedTags = <String>[];

  textController.addListener(() {
    isButtonEnabled.value = textController.text.isNotEmpty;
  });

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
              child: Column(
                children: [
                  Column(
                    children: [
                      TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          labelText: '何したい？',
                        ),
                        onChanged: (value) {
                          newHimaActivity = value;
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isButtonEnabled,
                        builder: (context, value, child) {
                          return ElevatedButton(
                            onPressed: value
                                ? () async {
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
                                    textController.clear();
                                  }
                                : null,
                            child: const Text('選択肢に追加'),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Wrap(
                    runSpacing: 16,
                    spacing: 16,
                    children: tags.map((tag) {
                      // selectedTags の中に自分がいるかを確かめる
                      final isSelected = selectedTags.contains(tag);
                      return InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32)),
                        onTap: () {
                          if (isSelected) {
                            // すでに選択されていれば取り除く
                            selectedTags.remove(tag);
                          } else {
                            // 選択されていなければ追加する
                            selectedTags.add(tag);
                          }
                          // setState(() {});
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                            border: Border.all(
                              width: 2,
                              color: Colors.pink,
                            ),
                            color: isSelected ? Colors.pink : null,
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Column(
                    children: [
                      Text("選択肢1"),
                      Text("選択肢2"),
                    ],
                  )
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
