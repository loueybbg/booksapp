// ignore: import_of_legacy_library_into_null_safe
import 'package:book_tracker/constants/constants.dart';
import 'package:flutter/material.dart';

class TwoSidedRoundeButton extends StatelessWidget {
  final String text;
  final double radius;
  final Function press;
  final Color color;

  const TwoSidedRoundeButton({
    Key? key,
    required this.text,
    this.radius = 30,
    required this.press,
    this.color = kBlackColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: press(),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius))),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ));
  }
}
