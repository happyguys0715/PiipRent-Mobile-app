import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:piiprent/helpers/colors.dart';

import '../../../widgets/size_config.dart';

class BreakDurationBoxWidget extends StatelessWidget {
  BreakDurationBoxWidget({this.initialTime, this.onTimeSelected, Key? key})
      : super(key: key);

  final TimeOfDay? initialTime;
  final Function? onTimeSelected;
  final RxString? selectedBreakTimeStr = 'Time'.obs;

  @override
  Widget build(BuildContext context) {
    selectedBreakTimeStr?.value = initialTime != null
        ? '${initialTime?.hour}h ${initialTime?.minute}m'
        : '0h 0m';
    return Expanded(
      child: InkWell(
        onTap: () async {
          TimeOfDay? result = await showTimePicker(
              builder: (context, snapshot) {
                return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: snapshot!);
              },
              context: context,
              initialTime: initialTime ?? TimeOfDay(hour: 0, minute: 0));
          if (result != null) {
            selectedBreakTimeStr?.value = '${result.hour}h ${result.minute}m';
            onTimeSelected?.call(result);
          }
        },
        child: Ink(
          padding: EdgeInsets.symmetric(
            // horizontal: 16,
            // vertical: 18,
            horizontal: SizeConfig.widthMultiplier * 3.89,
            vertical: SizeConfig.heightMultiplier * 2.86,
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
                  selectedBreakTimeStr!.value,
                  style: TextStyle(
                    //fontSize: 16,
                    fontSize:SizeConfig.heightMultiplier*2.34,
                    color: AppColors.lightBlack,
                  ),
                ),
              ),
              SvgPicture.asset(
                "images/icons/ic_time_duration.svg",
                height:SizeConfig.heightMultiplier*3.51,
                width:SizeConfig.widthMultiplier*5.84,
                // height: 24,
                // width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
