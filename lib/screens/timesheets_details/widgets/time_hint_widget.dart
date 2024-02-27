import 'package:flutter/material.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/widgets/size_config.dart';

class TimeHintWidget extends StatelessWidget {
  const TimeHintWidget(this.hintText, {Key? key}) : super(key: key);

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          //size: 5,
          size: SizeConfig.heightMultiplier*0.73,
          color: Colors.blue,
        ),
        SizedBox(
          //width: 6,
          width: SizeConfig.widthMultiplier*1.46,
        ),
        Text(
          hintText,
          style: TextStyle(
            color: AppColors.grey,
            //fontSize: 12,
            fontSize: SizeConfig.heightMultiplier*1.76,
          ),
        ),
      ],
    );
  }
}
