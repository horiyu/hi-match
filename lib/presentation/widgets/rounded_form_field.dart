import 'package:flutter/material.dart';

class RoundedFormField extends StatelessWidget {
  final String hintText;
  final double height;
  final double width;
  final Function(String) onChanged;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const RoundedFormField({
    super.key,
    required this.hintText,
    required this.height,
    required this.width,
    required this.onChanged,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
