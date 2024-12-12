import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef Fn = Function({required List<Map<String, String>> himaActivities});

Future<void> himaActivityList({
  required BuildContext context,
  final String? uid,
  required Fn handler,
}) async {
  String newHimaActivity = "";
  final textController = TextEditingController();
  final isButtonEnabled = ValueNotifier<bool>(false);
  var selectedTags = <Map<String, String>>[];

  textController.addListener(() {
    isButtonEnabled.value = textController.text.isNotEmpty;
  });

  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("id", isEqualTo: uid)
            .get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (userSnapshot.hasError) {
            return const Text('エラーが発生しました');
          }
          if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
            return const Text('ユーザーが見つかりません');
          }

          final userId = userSnapshot.data!.docs[0].id;

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
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(userId)
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
                      const SizedBox(height: 50),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(userId)
                            .collection("himaActivities")
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Text('エラーが発生しました');
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Text('タグが見つかりません');
                          }

                          // final tags = snapshot.data!.docs
                          //     .map((doc) => doc['content'] as String)
                          //     .toList();
                          // final tagsId = snapshot.data!.docs
                          //     .map((doc) => doc.id as String)
                          //     .toList();

                          final tagsWithIds = snapshot.data!.docs.map((doc) {
                            return {
                              'id': doc.id,
                              'content': doc['content'] as String,
                            };
                          }).toList();

                          return Wrap(
                            runSpacing: 16,
                            spacing: 16,
                            children: tagsWithIds.map((tag) {
                              final isSelected = selectedTags.contains(tag);
                              print("selectedTags:");
                              print(selectedTags);
                              print("tag:");
                              print(tag);
                              print("isSelected");
                              print(isSelected);
                              print("");
                              return InkWell(
                                // borderRadius:
                                //     const BorderRadius.all(Radius.circul),
                                onTap: () {
                                  if (isSelected) {
                                    selectedTags.remove(tag);
                                  } else {
                                    selectedTags.add(tag);
                                  }
                                  // print(isSelected);
                                  // print(selectedTags);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(32)),
                                    border: Border.all(
                                        width: 2, color: Colors.pink),
                                    color: isSelected ? Colors.pink : null,
                                  ),
                                  child: Text(
                                    tag['content']!,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.pink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
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
                          backgroundColor: WidgetStateProperty.all(Colors.grey),
                          minimumSize:
                              WidgetStateProperty.all(const Size(150, 45)),
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
                              WidgetStateProperty.all(Colors.deepOrangeAccent),
                          minimumSize:
                              WidgetStateProperty.all(const Size(150, 45)),
                        ),
                        child: const Text(
                          '決定',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          handler(himaActivities: selectedTags);
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
    },
  );
}
