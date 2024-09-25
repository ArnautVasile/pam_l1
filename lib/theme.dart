// lib/text_theme.dart
import 'package:flutter/material.dart';

class MyText {
  static const TextStyle titleHeader = TextStyle(
    fontSize: 40.0,
    fontFamily: "CeraPro",
    color: Colors.black,
  );

  static const TextStyle inputTitle = TextStyle(
    fontSize: 14,
    fontFamily: "CeraPro",
    color: Colors.black,
  );

  static const TextStyle sliderIndicator = TextStyle(
    fontSize: 12.0,
    //fontFamily: "CeraPro",
    color: Color(0xFF667085),
  );
}

class MyInputField extends StatelessWidget {
  final String? hintText;

  final TextEditingController? controller;
  final TextInputType keyboardType;

  const MyInputField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350, // Fixed width
      height: 50, // Fixed height
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Color(0xFFE1E2E8)), // Hint text color
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFE1E2E8), // Border color when not focused
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFE1E2E8), // Border color when focused
            ),
          ),
        ),
      ),
    );
  }
}
