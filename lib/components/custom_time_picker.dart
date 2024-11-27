import 'dart:math';

import 'package:flutter/material.dart';

typedef Fn = Function({required DateTime date});

Future<void> showCustomTimePicker({
  required double sheetHeight,
  required double itemHeight,
  required double textSize,
  required Fn handler,
  required BuildContext context,
  DateTime? selectedTime,
}) async {
  final int currentHour = DateTime.now().hour;
  final int currentMinute = DateTime.now().minute;
  final int roundedMinute =
      ((currentMinute + 4) ~/ 5) * 5; // Round up to nearest multiple of 5
  final int startHour = 0;
  final int totalHours = 24;
  final int startMinute = 0;
  final int totalMinutes = 60;

  final int currentYear =
      DateTime.now().year - 16; // 何歳から登録できるかの制限値　適宜修正する（この例では16歳）
  final int startYear = currentYear - 110; // 125歳まで登録できることを想定
  final int totalYears = currentYear - startYear + 1;

  int selectedHour = currentHour;
  int selectedMinute = roundedMinute;

  int adjustedHour = currentHour;
  int adjustedMinute = roundedMinute;
  if (selectedTime != null) {
    selectedMinute = selectedTime.minute;
    selectedHour = selectedTime.hour;
    adjustedHour = selectedTime.hour;
    adjustedMinute = selectedTime.minute;
  } else if (roundedMinute == 60) {
    adjustedHour = (currentHour + 1) % 24;
    adjustedMinute = 0;
  }

  final FixedExtentScrollController hourController =
      FixedExtentScrollController(initialItem: adjustedHour);
  final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: adjustedMinute ~/ 5);

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
        height: sheetHeight,
        child: Stack(
          children: [
            Center(
              child: Container(
                height: itemHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 90), // Adjust the width to position correctly
                  Text(
                    '時',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                      width: 100), // Adjust the width to position correctly
                  Text(
                    '分',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 35), // Add some padding to the right
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(0),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              final DateTime now = DateTime.now();
                              final DateTime roundedNow = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                now.hour,
                                roundedMinute,
                              );
                              final DateTime newTime =
                                  roundedNow.add(const Duration(minutes: 30));
                              hourController.jumpToItem(newTime.hour);
                              minuteController.jumpToItem(newTime.minute ~/ 5);
                              selectedHour = newTime.hour;
                              selectedMinute = newTime.minute;
                              handler(date: newTime);
                            },
                            child: const Text('30分'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(0),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              final DateTime now = DateTime.now();
                              final DateTime roundedNow = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                now.hour,
                                roundedMinute,
                              );
                              final DateTime newTime =
                                  roundedNow.add(const Duration(hours: 1));
                              hourController.jumpToItem(newTime.hour);
                              minuteController.jumpToItem(newTime.minute ~/ 5);
                              selectedHour = newTime.hour;
                              selectedMinute = newTime.minute;
                              handler(date: newTime);
                            },
                            child: const Text('1時間'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(0),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              final DateTime now = DateTime.now();
                              final DateTime roundedNow = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                now.hour,
                                roundedMinute,
                              );
                              final DateTime newTime =
                                  roundedNow.add(const Duration(hours: 2));
                              hourController.jumpToItem(newTime.hour);
                              minuteController.jumpToItem(newTime.minute ~/ 5);
                              selectedHour = newTime.hour;
                              selectedMinute = newTime.minute;
                              handler(date: newTime);
                            },
                            child: const Text('2時間'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: itemHeight,
                          onSelectedItemChanged: (int index) {
                            selectedHour = (startHour + index) % totalHours;
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
                          controller: hourController,
                        ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: itemHeight,
                          onSelectedItemChanged: (int index) {
                            selectedMinute =
                                (startMinute + index * 5) % totalMinutes;
                          },
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                height: itemHeight,
                                child: Text(
                                  '${(startMinute + index * 5) % totalMinutes}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            },
                            childCount: totalMinutes ~/ 5,
                          ),
                          controller: minuteController,
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
                          handler(
                            date: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              selectedHour,
                              selectedMinute,
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
          ],
        ),
      );
    },
  );
}
