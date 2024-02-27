import 'package:flutter/material.dart';
import 'package:piiprent/widgets/size_config.dart';

class DetailsRecord extends StatelessWidget {
  final String? label;
  final String value;
  final Widget? button;

  DetailsRecord({this.label, required this.value, this.button});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 5,
        vertical: SizeConfig.heightMultiplier * 1.26,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (label != null)
            Container(
              width: SizeConfig.widthMultiplier * 32, // Adjust the width as needed
              child: Text(
                "$label:",
                style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 2.34,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          SizedBox(
            width: SizeConfig.widthMultiplier * 1.94,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
            ),
          ),
          if (button != null) button!, // This will place the button next to the text
        ],
      ),
    );
  }
}