import "package:flutter/material.dart";

class CommonButton extends StatelessWidget {
  const CommonButton({required this.onPressed, required this.name, super.key});
  final Function() onPressed;
  final String name;

  @override
  Widget build(BuildContext context) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.transparent),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
}