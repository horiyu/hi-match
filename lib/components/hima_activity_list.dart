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
  final selectedTagsNotifier = ValueNotifier<List<Map<String, String>>>([]);

  textController.addListener(() {
    isButtonEnabled.value = textController.text.isNotEmpty;
  });

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
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
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // タグ入力フィールド
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextField(
                        controller: textController,
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
                    // 「選択肢に追加」ボタン
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isButtonEnabled,
                        builder: (context, value, child) {
                          return ElevatedButton(
                            onPressed: value
                                ? () async {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(uid)
                                        .collection("himaActivities")
                                        .add({'content': newHimaActivity});
                                    textController.clear();
                                  }
                                : null,
                            child: const Text('選択肢に追加'),
                          );
                        },
                      ),
                    ),
                    // タグリスト表示
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .doc(uid)
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
                                        selectedTags.add(tag);
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
                            },
                          );
                        },
                      ),
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
                    // 下部の「決定」「閉じる」ボタン
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              minimumSize: const Size(150, 45),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              '閉じる',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              minimumSize: const Size(150, 45),
                            ),
                            onPressed: () {
                              handler(
                                  himaActivities: selectedTagsNotifier.value);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              '決定',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
