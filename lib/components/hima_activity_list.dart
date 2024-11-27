import 'package:flutter/material.dart';

class HimaActivityList extends StatelessWidget {
  const HimaActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10, // Adjust the number of buttons as needed
      itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          minimumSize: WidgetStateProperty.all(const Size(300, 50)),
          maximumSize: WidgetStateProperty.all(const Size(300, 50)),
        ),
        onPressed: () {
          // Define the button action here
        },
        child: Text('Button $index'),
        ),
      );
      },
    );
  }
}
