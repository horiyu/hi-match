import 'package:flutter/material.dart';

typedef Fn = Function({required DateTime date});

Future<void> showCustomTimePicker({
  required double sheetHeight,
  required double itemHeight,
  required double textSize,
  required Fn handler,
  required BuildContext context,
}) async {
  final int currentHour = DateTime.now().hour;
  final int currentMinute = DateTime.now().minute;
  final int startHour = 0;
  final int totalHours = 24;
  final int startMinute = 0;
  final int totalMinutes = 60;

  final int currentYear =
      DateTime.now().year - 16; // 何歳から登録できるかの制限値　適宜修正する（この例では16歳）
  final int startYear = currentYear - 110; // 125歳まで登録できることを想定
  final int totalYears = currentYear - startYear + 1;
  int scrollHintIndex = currentHour; // 「上下にスクロール」の初期位置 適宜修正する

  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: sheetHeight,
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 10),
                  child: Center(
                    child: Text(
                      '時間を入力',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: itemHeight,
                          onSelectedItemChanged: (int index) {
                            scrollHintIndex = index;
                          },
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                height: itemHeight,
                                child: Text(
                                  '${(startHour + index) % totalHours}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            },
                            childCount: totalHours,
                          ),
                          controller: FixedExtentScrollController(
                            initialItem: currentHour,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: itemHeight,
                          onSelectedItemChanged: (int index) {
                            scrollHintIndex = index;
                          },
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                height: itemHeight,
                                child: Text(
                                  '${(startMinute + index) % totalMinutes}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            },
                            childCount: totalMinutes,
                          ),
                          controller: FixedExtentScrollController(
                            initialItem: currentMinute,
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
                          backgroundColor: WidgetStateProperty.all(Colors.grey),
                          minimumSize:
                              WidgetStateProperty.all(const Size(150, 45)),
                        ),
                        child: const Text('閉じる'),
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
                        child: const Text('決定'),
                        onPressed: () {
                          handler(
                            date: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              (startHour + scrollHintIndex) % totalHours,
                              (startMinute + scrollHintIndex) % totalMinutes,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
