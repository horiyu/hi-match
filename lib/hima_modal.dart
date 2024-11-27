import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'components/custom_time_picker.dart';

class HimaModal extends StatelessWidget {
  const HimaModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
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
          )
          // _selectTime(context),
        ],
      ),
    );
  }
}
