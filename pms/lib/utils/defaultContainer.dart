import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pms/utils/constants.dart';

class DefaultContainer extends StatelessWidget {
  final Widget? child;

  const DefaultContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Constants.altColor,
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          border: Border.all(color: Constants.backgroundColor, width: 2.0)),
      child: child,
    );
  }
}
