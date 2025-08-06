import 'package:flutter/material.dart';

class AuthenticationTexformfield extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hinttext;
  final Icon icon;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const AuthenticationTexformfield({
    super.key,
    required this.textEditingController,
    required this.hinttext,
    required this.icon,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.yellow),
        labelText: hinttext,
        labelStyle: const TextStyle(color: Colors.white),
        hintText: hinttext,
        hintStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon.icon, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.yellow),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.yellow, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      autofillHints: const [AutofillHints.email],
      validator: validator,
      autovalidateMode: autovalidateMode,
    );
  }
}
