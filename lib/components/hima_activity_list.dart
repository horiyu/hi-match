import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

typedef Fn = Function({required List<Map<String, String>> himaActivities});
final formKey = GlobalKey<FormState>();

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
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height,
    ),
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
            height: MediaQuery.of(context).size.height,
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
                            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                            child: Form(
                              key: formKey,
                              child: TextField(
                                controller: textController,
                                inputFormatters: [
                                  // 最大10文字まで入力可能
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: InputDecoration(
                                  labelText: '何したい？',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                ),
                                onChanged: (value) {
                                  newHimaActivity = value;
                                },
                              ),
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
                                      final snapshot = await FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(userId)
                                          .collection("himaActivities")
                                          .get();

                                      if (snapshot.docs.length >= 5) {
                                        errorNotifier.value =
                                            "タグの数が5個を超えています。追加できません。";
                                        return;
                                      }

                                      final docRef = FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(userId)
                                          .collection("himaActivities")
                                          .doc(); // ドキュメントIDを生成

                                      await docRef.set({
                                        'content': newHimaActivity,
                                        'HimaActivitiesID':
                                            docRef.id, // ドキュメントIDを格納
                                      });

                                      textController.clear();
                                      errorNotifier.value =
                                          null; // エラーメッセージをクリア
                                    }
                                  : null,
                              child: const Text('選択肢に追加'),
                            );
                          },
                        ),
                      ),
                      ValueListenableBuilder<String?>(
                        valueListenable: errorNotifier,
                        builder: (context, error, child) {
                          return error != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    error,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 50),
                      StreamBuilder<QuerySnapshot>(
                        //リアルタイムでタグを表示
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(userId)
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

                          final tagsWithIds = snapshot.data!.docs.map((doc) {
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
                                        (map) => map.containsValue(tag['id']));

                                    return InkWell(
                                      onTap: () {
                                        if (isSelected) {
                                          selectedTags.removeWhere(
                                              (map) => map['id'] == tag['id']);
                                        } else {
                                          if (selectedTags.length < 6) {
                                            // タグの数を6個に制限
                                            selectedTags.add(tag);
                                          }
                                        }
                                        selectedTagsNotifier.value =
                                            List.from(selectedTags);
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 30),
                          ),
                          onPressed: () async {
                            // Firestore内のタグをすべて削除
                            final activities = await FirebaseFirestore.instance
                                .collection("users")
                                .doc(userId)
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.deepOrangeAccent),
                          minimumSize:
                              MaterialStateProperty.all(const Size(150, 45)),
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
              ],
            ),
          );
        },
      );
    },
  );
}
