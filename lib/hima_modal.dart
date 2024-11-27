import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'components/custom_time_picker.dart';

class HimaModal extends StatelessWidget {
  const HimaModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
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
          const Text('BottomSheet Content1'),
          ElevatedButton(
            onPressed: () async {
              await showCustomTimePicker(
                sheetHeight: 500,
                itemHeight: 35,
                textSize: 20,
                handler: ({required DateTime date}) {
                  // setState(() {
                  //   selectedDate = date;
                  // });
                },
                context: context,
              );
            },
            child: const Text('Pick Date and Time'),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.grey),
                    minimumSize: WidgetStateProperty.all(const Size(150, 45)),
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
                    minimumSize: WidgetStateProperty.all(const Size(150, 45)),
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
  }
}
