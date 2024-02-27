import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/widgets/size_config.dart';

// ignore: must_be_immutable
class TimeAddWidget extends StatelessWidget {
   TimeAddWidget(this.hintText, this.dateTime, {this.widthFixed=true, Key? key})
      : super(key: key);
  final String hintText;
  final dynamic dateTime;
  bool widthFixed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.only(
          //bottom: 16.0,
          bottom:SizeConfig.heightMultiplier * 1.5,
          left: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: widthFixed ? Get.width * 0.22 : null,
            child: Text(
              hintText + ': ',
              style: TextStyle(
                color: AppColors.grey,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.heightMultiplier * 1.76,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                dateTime is DateTime
                    ? formatDateTime(dateTime)
                    : dateTime.toString(),
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.heightMultiplier * 1.76,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
