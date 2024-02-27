import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:piiprent/widgets/toast.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:piiprent/screens/timesheets_details/widgets/date_picker_box_widget.dart';
import 'package:piiprent/screens/timesheets_details/widgets/time_hint_widget.dart';
import 'package:piiprent/screens/timesheets_details/widgets/break_duration_box_widget.dart';
import 'package:piiprent/screens/timesheets_details/widgets/time_picker_box_widget.dart';

// ignore: must_be_immutable
class TimeSheetWidgetPage extends StatefulWidget {
  TimeSheetWidgetPage(this.times, this.timezone, {Key? key}) : super(key: key);
  Map<String, DateTime?> times;
  final String timezone;

  @override
  State<TimeSheetWidgetPage> createState() => _TimeSheetWidgetPageState();
}

class _TimeSheetWidgetPageState extends State<TimeSheetWidgetPage> {
  String _shiftStart = TimesheetTimeKey[TimesheetTime.Start]!;
  String _breakStart = TimesheetTimeKey[TimesheetTime.BreakStart]!;
  String _breakEnd = TimesheetTimeKey[TimesheetTime.BreakEnd]!;
  String _shiftEnd = TimesheetTimeKey[TimesheetTime.End]!;
  Duration? breakDuration;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color:Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: SizeConfig.heightMultiplier * 5.27,
              ),
              onPressed: () {
                Get.back();
              },
            );
          },
        ),
        backgroundColor: Colors.blue[500],
        title: Text(
          'Time',
          style: TextStyle(
            fontSize: SizeConfig.heightMultiplier * 2.64,
            color: Colors.white
          ),
        ),
        centerTitle: false,
        
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              size: SizeConfig.heightMultiplier * 3.81,
              color: Colors.white
            ),
            onPressed: () {
              validateInputs();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.heightMultiplier * 2.93,
          horizontal: SizeConfig.widthMultiplier * 3.89,
        ),
        child: Column(
          children: [
            TimeHintWidget('START TIME',),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1.76,
            ),
            Row(
              children: [
                DatePickerBoxWidget(
                  initialDate: widget.times[_shiftStart]!,
                  onDateSelected: (DateTime startDate) {
                    TZDateTime _dateTime = TZDateTime(
                      getLocation(widget.timezone),
                      startDate.year,
                      startDate.month,
                      startDate.day,
                      widget.times[_shiftStart]?.hour ?? 0,
                      widget.times[_shiftStart]?.minute ?? 0,
                    );
                    widget.times[_shiftStart] = _dateTime;
                  },
                ),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 3.89,
                ),
                TimePickerBoxWidget(
                  timezone1: widget.timezone,
                  initialDateTime: widget.times[_shiftStart] ?? tz.TZDateTime.now(tz.getLocation(widget.timezone)),
                  onTimeSelected: (DateTime startTime) {
                    // Use the current date if widget.times[_shiftStart] is null
                    TZDateTime _dateTime = tz.TZDateTime(
                      tz.getLocation(widget.timezone),
                      widget.times[_shiftStart]?.year ?? DateTime.now().year,
                      widget.times[_shiftStart]?.month ?? DateTime.now().month,
                      widget.times[_shiftStart]?.day ?? DateTime.now().day,
                      startTime.hour,
                      startTime.minute,
                    );
                    setState(() {
                      widget.times[_shiftStart] = _dateTime;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1.34,
            ),
            TimeHintWidget('END TIME',),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1.76,
            ),
            Row(
              children: [
                DatePickerBoxWidget(
                  initialDate: widget.times[_shiftEnd],
                  onDateSelected: (DateTime endDate) {
                    TZDateTime _dateTime = TZDateTime(
                      getLocation(widget.timezone),
                      endDate.year,
                      endDate.month,
                      endDate.day,
                      widget.times[_shiftEnd]?.hour ?? 0,
                      widget.times[_shiftEnd]?.minute ?? 0,
                    );
                    widget.times[_shiftEnd] = _dateTime;
                  },
                ),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 3.89,
                ),
                TimePickerBoxWidget(
                  timezone1: widget.timezone,
                  initialDateTime: widget.times[_shiftEnd],
                  onTimeSelected: (DateTime endtime) {
                    // Use the current date if widget.times[_shiftStart] is null
                    TZDateTime _dateTime = tz.TZDateTime(
                      tz.getLocation(widget.timezone),
                      widget.times[_shiftEnd]?.year ?? DateTime.now().year,
                      widget.times[_shiftEnd]?.month ?? DateTime.now().month,
                      widget.times[_shiftEnd]?.day ?? DateTime.now().day,
                      endtime.hour,
                      endtime.minute,
                    );
                    setState(() {
                      widget.times[_shiftEnd] = _dateTime;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2.93,
            ),
            TimeHintWidget('BREAK TIME',),
            SizedBox(
              height: SizeConfig.heightMultiplier * 1.76,
            ),
            Row(
              children: [
                BreakDurationBoxWidget(
                  initialTime: calculateBreakDuration(),
                  onTimeSelected: (TimeOfDay breakTime) {
                    breakDuration = Duration(
                      hours: breakTime.hour,
                      minutes: breakTime.minute,
                    );
                  },
                ),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 3.89,
                ),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 5.86,
            ),
            Container(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  validateInputs();
                },
                //height: 40,
                height: SizeConfig.heightMultiplier * 5.86,
                child: Text(
                  'SUBMIT',
                  style: TextStyle(
                    fontSize:SizeConfig.heightMultiplier * 2.05,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: AppColors.darkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100), // <-- Radius
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TimeOfDay? calculateBreakDuration() {
    try {
      Duration time = widget.times[_breakEnd]!.difference(widget.times[_breakStart]!);
      if (time != Duration.zero) {
        breakDuration = time;
        return TimeOfDay(hour: time.inHours, minute: time.inMinutes % 60);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void validateInputs() {
    if (widget.times[_shiftStart] == null) {
      toast('Start date required');
      return;
    }

    if (widget.times[_shiftStart]!.hour == 0) {
      toast('Start time required');
      return;
    }

    if (widget.times[_shiftEnd] == null) {
      toast('End date required');
      return;
    }

    if (widget.times[_shiftEnd]!.hour == 0 && widget.times[_shiftEnd]!.minute == 0) {
      toast('End time required');
      return;
    }

    var value = widget.times[_shiftEnd]!.difference(widget.times[_shiftStart]!);
    if (value.isNegative) {
      toast('End time can\'t be earlier than the start time');
      return;
    }

    widget.times[_breakStart] = widget.times[_shiftStart]!.add(Duration(hours: 2));

    // if ((widget.times[_breakEnd]!.hour == 0 && widget.times[_breakEnd]!.minute == 0) || breakDuration == null) {
    //   toast('Break time is required');
    //   return;
    // }

    // value = times[_shiftEnd].difference(times[_breakStart]);
    //
    // if (value.isNegative) {
    //   Get.snackbar('Break at after 2 hours of shift start',
    //       'Shift start - Shift end: ${times[_shiftStart].hour} - ${times[_shiftEnd].hour} ');
    //
    //   return;
    // }

    if (breakDuration != null) {
      widget.times[_breakEnd] = widget.times[_breakStart]!.add(
        Duration(
          hours: breakDuration!.inHours,
          minutes: (breakDuration!.inMinutes % 60),
        ),
      );
    }

    var shiftDuration = widget.times[_shiftEnd]!.difference(widget.times[_shiftStart]!);
    var breakLength = widget.times[_breakEnd]!.difference(widget.times[_breakStart]!);
    
    if (!(shiftDuration > breakLength)) {
      toast('Break time can\'t be more than or equal to ( ${shiftDuration.toString().split(':')[0]} ) hours');
      return;
    }

    Get.back(result: widget.times);
  }
}
