import 'package:flutter/material.dart';

class CommonTextfield extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hinttext;
  final int? maxlines;
  final bool? enabled;
  const CommonTextfield({super.key, required this.textEditingController, required this.hinttext, this.maxlines, this.enabled});

  @override
  Widget build(BuildContext context) {
    return  TextField(
              controller: textEditingController,
              maxLines: maxlines,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2D2D2D),
              ),
              textInputAction: TextInputAction.done,
              enabled: enabled,
              decoration: InputDecoration(
                hintText: hinttext,
                hintStyle: TextStyle(
                  color: const Color(0xFF2D2D2D).withAlpha(72),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFA58EF5),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFA58EF5),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFA58EF5),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            );
  }
}