import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/widgets/size_config.dart';

class GeneralInformationWidget extends StatelessWidget {
  String? imageIcon;
  String? name;
  String? value;
  double? width;

  GeneralInformationWidget(
      {this.imageIcon, this.name, this.value, Key? key, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        //bottom: 17,
        bottom: SizeConfig.heightMultiplier * 1.5,
        left: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // if (imageIcon != null)
          //   SvgPicture.asset(
          //     imageIcon!,
          //     // width: 10,
          //     // height: 12,
          //     width: SizeConfig.widthMultiplier * 2.43,
          //     height: SizeConfig.heightMultiplier * 1.76,
          //   ),
          // if (imageIcon != null)
          //   SizedBox(
          //     //width: 6,
          //     width: SizeConfig.widthMultiplier * 1.46,
          //   ),
          Container(
            // decoration: BoxDecoration(border: Border.all()),
            alignment: Alignment.topLeft,
            width: Get.width * 0.22,
            child: Text(
              name! + ": ",
              style: TextStyle(
                // fontStyle: 12,
                fontFamily: GoogleFonts.roboto().fontFamily,
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.heightMultiplier * 1.76,
              ),
            ),
          ),
          Container(
            // decoration: BoxDecoration(border: Border.all()),
            alignment: Alignment.topLeft,
            width: width ?? Get.width * 0.6,
            child: Text(
              value!,
              style: TextStyle(
                color: AppColors.black,
                //fontSize: 12,
                fontSize: SizeConfig.heightMultiplier * 1.76,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
