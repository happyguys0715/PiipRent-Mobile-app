import 'package:flutter/material.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/widgets/size_config.dart';

class FormMessage extends StatelessWidget {
  final MessageType? type;
  final String? message;

  FormMessage({
    this.type,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    Color color = type == MessageType.Error ? Colors.red : Colors.green;

    if (message != null) {
      return Padding(
        padding: EdgeInsets.all(
          //8.0,
          SizeConfig.heightMultiplier * 1.17,
        ),
        child: Center(
          child: Text(
            this.message!,
            style: TextStyle(
              color: color,
              fontSize: SizeConfig.heightMultiplier * 2.34,
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
