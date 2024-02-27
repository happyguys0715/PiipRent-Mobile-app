import 'package:flutter/material.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/widgets/size_config.dart';

class StepComponent extends StatelessWidget {
  final bool? done;
  final bool? active;
  final String? label;
  final String? number;
  const StepComponent({
    Key? key,
    this.done,
    this.active,
    this.label,
    this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 70,
      width: SizeConfig.widthMultiplier * 17.03,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            child: done!
                ? Icon(
                    Icons.check,
                    color: whiteColor,
                    //size: 15,
                    size: SizeConfig.heightMultiplier * 2.34,
                  )
                : active!
                    ? Text(
                        number!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            //fontSize: 14,
                            fontSize: SizeConfig.heightMultiplier * 2.05,
                            color: whiteColor),
                      )
                    : Text(
                        number!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            //fontSize: 14,
                            fontSize: SizeConfig.heightMultiplier * 2.05,
                            color: greyColor.withOpacity(.5)),
                      ),
            //radius: 15,
            radius: SizeConfig.heightMultiplier * 2.34,
            backgroundColor: done!
                ? successColor
                : active!
                    ? primaryColor
                    : lightBlue,
          ),
          SizedBox(
            //height: 10,
            height: SizeConfig.heightMultiplier * 1.46,
          ),
          FittedBox(
            child: Text(
              label!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                //fontSize: 14,
                fontSize: SizeConfig.heightMultiplier * 2.05,
                height: 1.1,
                color: done!
                    ? successColor
                    : active!
                        ? primaryColor
                        : greyColor.withOpacity(.5),
              ),
            ),
          )
        ],
      ),
    );
  }
}
