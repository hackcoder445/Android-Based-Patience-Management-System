import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultText.dart';

class DefaultGesture extends StatelessWidget {
  final String svgAsset;
  final String tag;
  Function()? func;
  DefaultGesture(
      {Key? key, required this.svgAsset, required this.tag, this.func})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Column(
        children: [
          ClipOval(
            child: Container(
              color: Constants.altColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  svgAsset,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
          DefaultText(
            text: tag,
            size: 18.0,
            color: Constants.primaryColor,
          )
        ],
      ),
    );
  }
}
