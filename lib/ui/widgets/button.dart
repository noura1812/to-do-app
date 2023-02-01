import 'package:flutter/material.dart';
import 'package:to_do_list/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.label, required this.ontp})
      : super(key: key);
  final String label;
  final Function() ontp;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontp,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryClr,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 100,
        height: 45,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
