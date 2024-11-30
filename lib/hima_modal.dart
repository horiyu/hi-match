import 'package:flutter/material.dart';
import 'package:my_web_app/components/hima_activity_list.dart';
import 'components/custom_time_picker.dart';

class HimaModal extends StatefulWidget {
  const HimaModal({super.key});

  @override
  _HimaModalState createState() => _HimaModalState();
}

class _HimaModalState extends State<HimaModal> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0, // 初期の高さ
      minChildSize: 1.0, // 最小の高さ
      maxChildSize: 1.0, // 最大の高さ
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  minimumSize: WidgetStateProperty.all(const Size(300, 50)),
                  maximumSize: WidgetStateProperty.all(const Size(300, 50)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ひま時間'),
                    Row(
                      children: [
                        if (selectedDate == null)
                          const Text('時間を選択')
                        else
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '〜 ${selectedDate!.hour.toString().padLeft(2, '0')}:${selectedDate!.minute.toString().padLeft(2, '0')}',
                              ),
                              Builder(
                                builder: (context) {
                                  final now = DateTime.now();
                                  final difference = selectedDate!.isBefore(now)
                                      ? selectedDate!
                                          .add(const Duration(days: 1))
                                          .difference(now)
                                      : selectedDate!.difference(now);
                                  final differenceText = difference.inMinutes >=
                                          60
                                      ? '残り ${difference.inHours}時間 ${difference.inMinutes.remainder(60).toString().padLeft(2, '0')}分'
                                      : '残り ${difference.inMinutes}分';
                                  return Text(
                                    differenceText,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  );
                                },
                              ),
                            ],
                          ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.chevron_right,
                        ),
                      ],
                    ),
                  ],
                ),
                onPressed: () async {
                  await showCustomTimePicker(
                    sheetHeight: 500,
                    itemHeight: 35,
                    textSize: 20,
                    selectedTime: selectedDate,
                    handler: ({required DateTime date}) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    context: context,
                  );
                },
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  minimumSize: WidgetStateProperty.all(const Size(300, 50)),
                  maximumSize: WidgetStateProperty.all(const Size(300, 50)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ひまつぶしを設定する'),
                    Row(
                      children: [
                        if (selectedDate == null)
                          const Text('選択')
                        else
                          const Text('選択'),
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [
                        //     Text(
                        //       '〜 ${selectedDate!.hour.toString().padLeft(2, '0')}:${selectedDate!.minute.toString().padLeft(2, '0')}',
                        //     ),
                        //     Builder(
                        //       builder: (context) {
                        //         final now = DateTime.now();
                        //         final difference = selectedDate!.isBefore(now)
                        //             ? selectedDate!
                        //                 .add(const Duration(days: 1))
                        //                 .difference(now)
                        //             : selectedDate!.difference(now);
                        //         final differenceText = difference.inMinutes >=
                        //                 60
                        //             ? '残り ${difference.inHours}時間 ${difference.inMinutes.remainder(60).toString().padLeft(2, '0')}分'
                        //             : '残り ${difference.inMinutes}分';
                        //         return Text(
                        //           differenceText,
                        //           style: const TextStyle(
                        //               fontSize: 10, color: Colors.grey),
                        //         );
                        //       },
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.chevron_right,
                        ),
                      ],
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              // Expanded(
              //   child: SingleChildScrollView(
              //     controller: scrollController,
              //     child: const SizedBox(
              //       width: 300,
              //       child: HimaActivityList(),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  minimumSize: WidgetStateProperty.all(const Size(300, 50)),
                  maximumSize: WidgetStateProperty.all(const Size(300, 50)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('公開範囲を設定する'),
                    Row(
                      children: [
                        if (selectedDate == null)
                          const Text('選択')
                        else
                          const Text('選択'),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.chevron_right,
                        ),
                      ],
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.deepOrangeAccent),
                        minimumSize:
                            WidgetStateProperty.all(const Size(300, 50)),
                      ),
                      child: const Text(
                        'ひま',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
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
}
