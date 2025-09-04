import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    final neonGreen = const Color(0xFF39FF14);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: neonGreen),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonGreen.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonGreen, width: 2),
        ),
        fillColor: const Color.fromARGB(255, 0, 32, 79),
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: neonGreen.withOpacity(0.5)),
      ),
    );
  }
}
