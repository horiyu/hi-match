import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/state/hima_activity/notifier.dart';
import '../../application/state/hima_activity/provider.dart';
import '../../domain/types/hima_activity.dart';

typedef Fn = Function({required String himaActivities});

// final himaActivityProvider =
//     StateNotifierProvider<HimaActivityNotifier, AsyncValue<List<HimaActivity>>>(
//         (ref) {
//   return HimaActivityNotifier();
// });

Future<void> himaActivityList({
  required BuildContext context,
  final String? uid,
  required Fn handler,
}) async {
  String newHimaActivity = "";
  final textController = TextEditingController();
  final isButtonEnabled = ValueNotifier<bool>(false);
  var selectedTags = <String>[];

  textController.addListener(() {
    isButtonEnabled.value = textController.text.isNotEmpty;
  });

  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final himaActivitiesAsyncValue = ref.watch(himaActivityProvider);

          print(himaActivitiesAsyncValue);

          return himaActivitiesAsyncValue.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, stack) => const Text('エラーが発生しました'),
            data: (himaActivities) {
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
                                            .doc(uid)
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
                          Wrap(
                            runSpacing: 16,
                            spacing: 16,
                            children: himaActivities.map((activity) {
                              final isSelected =
                                  selectedTags.contains(activity.content);
                              return InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                onTap: () {
                                  if (isSelected) {
                                    selectedTags.remove(activity.content);
                                  } else {
                                    selectedTags.add(activity.content);
                                  }
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
                                    activity.content,
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
                              minimumSize: MaterialStateProperty.all(
                                  const Size(150, 45)),
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
                              minimumSize: MaterialStateProperty.all(
                                  const Size(150, 45)),
                            ),
                            child: const Text(
                              '決定',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              handler(
                                himaActivities: selectedTags.join(', '),
                              );
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
    },
  );
}
