import 'package:flutter/material.dart';

Future<void> himaActivityList({
  required BuildContext context,
  required Null Function({required DateTime date}) handler,
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
        height: 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      // controller: hourController,
                      decoration: const InputDecoration(
                        labelText: '何したい？',
                      ),
                      onChanged: (value) {
                        newHimaActivity = value;
                      },
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
                      // handler(
                      //   date: DateTime(
                      //     DateTime.now().year,
                      //     DateTime.now().month,
                      //     DateTime.now().day,
                      //     selectedHour,
                      //     selectedMinute,
                      //   ),
                      // );
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
