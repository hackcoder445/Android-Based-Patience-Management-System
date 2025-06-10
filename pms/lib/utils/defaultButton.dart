import 'package:flutter/material.dart';
import 'package:pms/utils/constants.dart';


class DefaultButton extends StatelessWidget {
  final Function onPressed;
  // final String text;
  final double? textSize;
  final FontWeight? textWeight;
  final Size? size;
  Color? color;
  Color? textColor;
  Widget? child;

  DefaultButton(
      {Key? key,
      required this.onPressed,
      // required this.text,
      this.textSize,
      this.color = Constants.primaryColor,
      this.textColor,
      this.textWeight,
      this.size,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          padding: MaterialStateProperty.all(const EdgeInsets.all(15.0)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: child);
  }
}
