import 'package:flutter/material.dart';

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
      child: const Center(
        child: Text('BottomSheet Content1'),
      ),
    );
  }
}
