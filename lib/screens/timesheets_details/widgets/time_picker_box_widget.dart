import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../../widgets/size_config.dart';

class TimePickerBoxWidget extends StatelessWidget {
  TimePickerBoxWidget(
      {Key? key, this.onTimeSelected, this.initialTime, this.initialDateTime, this.timezone1})
      : super(key: key);
  final String? timezone1;
  final Function? onTimeSelected;
  final TimeOfDay? initialTime;
  final DateTime? initialDateTime;
  final RxString selectedTimeStr = 'Time'.obs;

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    var locations = tz.timeZoneDatabase.locations;

    selectedTimeStr.value = initialDateTime != null
        ? TimeOfDay(hour: initialDateTime!.hour, minute: initialDateTime!.minute)
            .format(context)
        : 'Time';
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () async {
          var result = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: initialDateTime?.hour ?? 0,
              minute: initialDateTime?.minute ?? 0,
            ),
          );
          if (result != null) {
            onTimeSelected?.call(
              // TZDateTime(
              //   getLocation(this.timezone1!),
              //   initialDateTime?.year ?? DateTime.now().year,
              //   initialDateTime?.month ?? DateTime.now().month,
              //   initialDateTime?.day ?? DateTime.now().day,
              //   result.hour,
              //   result.minute,
              // ),
              DateTime(
                initialDateTime?.year ?? DateTime.now().year,
                initialDateTime?.month ?? DateTime.now().month,
                initialDateTime?.day ?? DateTime.now().day,
                result.hour,
                result.minute,
              ),
            );
          }
        },
        child: Ink(
          padding: EdgeInsets.symmetric(
            // horizontal: 16,
            // vertical: 18,
            horizontal:SizeConfig.widthMultiplier*3.89,
            vertical:SizeConfig.heightMultiplier*2.64,
          ),
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            border: Border.all(
              width: 1,
              color: AppColors.blueBorder,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  selectedTimeStr.value,
                  style: TextStyle(
                    //fontSize: 16,
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                    color: AppColors.lightBlack,
                  ),
                ),
              ),
              SvgPicture.asset(
                "images/icons/ic_time.svg",
                height: SizeConfig.heightMultiplier * 2.93,
                width: SizeConfig.widthMultiplier * 4.86,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
