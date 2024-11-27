import 'package:flutter/material.dart';
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
                selectedTime: selectedDate,
                handler: ({required DateTime date}) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                context: context,
              );
            },
            child: Text(
              selectedDate == null
                  ? '時間を選択'
                  : '${selectedDate!.hour.toString().padLeft(2, '0')}:${selectedDate!.minute.toString().padLeft(2, '0')}',
            ),
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
