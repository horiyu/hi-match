import 'package:flutter/material.dart';
import '../../components/custom_time_picker.dart';
import '../../components/hima_activity_list.dart';
import '../widgets/pill_outlined_button.dart';

class HimaModal extends StatefulWidget {
  final String uid;

  const HimaModal(this.uid, {super.key});

  @override
  _HimaModalState createState() => _HimaModalState();
}

class _HimaModalState extends State<HimaModal> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PillOutlinedButton(
            height: 50,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ひま時間'),
                Row(
                  children: [
                    if (selectedDate == null)
                      const Text('時間を選択')
                    else
                      Text(
                        '〜 ${selectedDate!.hour.toString().padLeft(2, '0')}:${selectedDate!.minute.toString().padLeft(2, '0')}',
                      ),
                    const SizedBox(width: 10),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          PillOutlinedButton(
            height: 50,
            onPressed: () async {
              await himaActivityList(
                handler: ({required String himaActivities}) {
                  setState(() {
                    // Handle himaActivities
                  });
                },
                context: context,
                uid: widget.uid,
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ひまつぶしを設定する'),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  selectedDate == null
                      ? Colors.deepOrangeAccent.withOpacity(0.5)
                      : Colors.deepOrangeAccent,
                ),
                minimumSize: MaterialStateProperty.all(const Size(300, 50)),
              ),
              onPressed: selectedDate == null ? null : () async {},
              child: const Text(
                'ひま',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
