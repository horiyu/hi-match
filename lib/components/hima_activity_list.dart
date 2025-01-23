import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

typedef Fn = Function({required List<Map<String, String>> himaActivities});

Future<void> himaActivityList({
  required BuildContext context,
  final String? uid,
  required Fn handler,
}) async {
  String newHimaActivity = "";
  final textController = TextEditingController();
  final isButtonEnabled = ValueNotifier<bool>(false);
  final selectedTagsNotifier = ValueNotifier<List<Map<String, String>>>([]);
  final errorNotifier = ValueNotifier<String?>(null); // エラーメッセージ用のNotifier

  textController.addListener(() {
    isButtonEnabled.value = textController.text.isNotEmpty;
  });

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20), // You can adjust this value
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextField(
                                        controller: textController,
                                        decoration: InputDecoration(
                                          labelText: '何したい？',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 15),
                                        ),
                                        onChanged: (value) {
                                          newHimaActivity = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20), // Adjust this value as needed
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable: isButtonEnabled,
                                    builder: (context, value, child) {
                                      return ElevatedButton(
                                        onPressed: value
                                            ? () async {
                                                await FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(userId)
                                                    .collection(
                                                        "himaActivities")
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
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(uid)
                                .collection("himaActivities")
                                .snapshots(),
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

                              final tagsWithIds =
                                  snapshot.data!.docs.map((doc) {
                                return {
                                  'id': doc.id,
                                  'content': doc['content'] as String,
                                };
                              }).toList();

                              return ValueListenableBuilder<
                                      List<Map<String, String>>>(
                                  valueListenable: selectedTagsNotifier,
                                  builder: (context, selectedTags, child) {
                                    return Wrap(
                                      runSpacing: 16,
                                      spacing: 16,
                                      children: tagsWithIds.map((tag) {
                                        final isSelected = selectedTags.any(
                                            (map) =>
                                                map.containsValue(tag['id']));
                                        return InkWell(
                                          // borderRadius:
                                          //     const BorderRadius.all(Radius.circul),
                                          onTap: () {
                                            final isSelected = selectedTags.any(
                                                (map) => map
                                                    .containsValue(tag['id']));
                                            // print(isSelected);

                                            // print(tag);
                                            // print(selectedTags);
                                            if (isSelected) {
                                              selectedTags.removeWhere((map) =>
                                                  map['id'] == tag['id']);
                                            } else {
                                              selectedTags.add(tag);
                                            }
                                            selectedTagsNotifier.value =
                                                List.from(selectedTags);
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(32)),
                                              border: Border.all(
                                                  width: 2, color: Colors.pink),
                                              color: isSelected
                                                  ? Colors.pink
                                                  : Colors.white,
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
                                  });
                            },
                          ),
                        ]),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("himaActivities")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return const Text(
                        'すべてのタグを消去',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
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
                          style: const ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.deepOrangeAccent),
                            minimumSize:
                                MaterialStateProperty.all(Size(150, 45)),
                          ),
                          child: const Text(
                            '決定',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            handler(himaActivities: selectedTagsNotifier.value);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("himaActivities")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      return const SizedBox(height: 20);
                    },
                  ),
                  // 「すべてのタグを消去」ボタン
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 30),
                      ),
                      onPressed: () async {
                        final activities = await FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
                            .collection("himaActivities")
                            .get();

                        for (var doc in activities.docs) {
                          await doc.reference.delete();
                        }

                        selectedTagsNotifier.value = []; // 表示をクリア
                        print("All tags have been deleted.");
                      },
                      child: const Text(
                        'すべてのタグを消去',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}
