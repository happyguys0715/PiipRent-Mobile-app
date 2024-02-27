import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piiprent/helpers/colors.dart';

import '../../../widgets/size_config.dart';

class DurationShowWidget extends StatelessWidget {
  const DurationShowWidget(this.hintText, this.duration, {Key? key})
      : super(key: key);
  final String hintText;
  final Duration duration;

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
            width: Get.width * 0.22,
            child: Text(
              hintText + ": ",
              style: TextStyle(
                color: AppColors.grey,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.heightMultiplier * 1.76,
                // fontSize: 12,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                '${duration.inHours}h ${duration.inMinutes % 60}m',
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.heightMultiplier * 1.76,
                  // fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
