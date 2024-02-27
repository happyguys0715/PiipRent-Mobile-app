import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/screens/client_timesheet_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';
import 'package:piiprent/widgets/size_config.dart';

class ClientTimesheetCard extends StatelessWidget {
  final Timesheet? timesheet;
  final Function? update;
  final bool unapprovedCard;

  ClientTimesheetCard({
    this.timesheet,
    this.update,
    required this.unapprovedCard,
  });

  String totalTime(DateTime? shift_end, DateTime? shift_start) {
    if (shift_end == null || shift_start == null) {
      return '-';
    }

    Duration duration = shift_end.difference(shift_start);
    String formattedTimeDifference = "${duration.inHours}h ${duration.inMinutes % 60}m";

    return formattedTimeDifference;
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);

    return GestureDetector(
      onTap: () async {
        var result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ClientTimesheetDetailsScreen(
              timesheet: timesheet!,
            ),
          ),
        );

        if (result) {
          update!();
        }
      },
      child: ListCard(
        header: Row(
          children: [
            SizedBox(
              // width: 16.0,
              width: SizeConfig.widthMultiplier * 1.0,
            ),
            Column(
              children: [
                Container(
                  // height: 70,
                  // width: 70,
                  height: SizeConfig.heightMultiplier * 10.25,
                  width: SizeConfig.widthMultiplier * 17.03,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    image: timesheet?.candidateAvatarUrl != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(timesheet!.candidateAvatarUrl!),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(
              // width: 16.0,
              width: SizeConfig.widthMultiplier * 3.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // width: SizeConfig.heightMultiplier * 3,
                    child: Text(
                      timesheet!.candidateName!,
                      maxLines: 1,
                      style: TextStyle(
                        // fontSize: 12.0,
                        fontSize: SizeConfig.heightMultiplier * 2.6,
                        color: Colors.white,
                      ),
                    ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 0.8,
                ),
                Container(
                  width: SizeConfig.widthMultiplier * 60, // Set an appropriate width
                  child: Text(
                    "${timesheet?.position(localizationDelegate.currentLocale)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.heightMultiplier * 2.6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    //horizontal: 6.0,
                    horizontal: SizeConfig.widthMultiplier * 1.46,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        5
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        timesheet!.score!,
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: SizeConfig.heightMultiplier * 2.34),
                      ),
                      SizedBox(
                        //width: 4.0,
                        width: SizeConfig.widthMultiplier * 0.97,
                      ),
                      Icon(
                        Icons.star,
                        //size: 14.0,
                        size: SizeConfig.heightMultiplier * 2.05,
                        color: Colors.amber,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 0.8,
                ),
              ],
            )
          ],
        ),
        body: Column(
          children: [    
            ListCardRecord(
              padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 0.7),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translate('timesheet.shift_started_at')}:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        timesheet?.shiftStart != null
                            ? DateFormat.jm().format(timesheet!.shiftStart!)
                            : '-',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
  
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            ListCardRecord(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 0.7),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translate('timesheet.break_time')}:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        timesheet?.breakStart != null
                            ? DateFormat.jm().format(timesheet!.breakStart!)
                            : '-',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
  
                        ),
                      ),
                      SizedBox(
                        //width: 5.0,
                        width: SizeConfig.widthMultiplier * 1.22,
                      ),
                      Text(
                        '-',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
  
                        ),
                      ),
                      SizedBox(
                        //width: 5.0,
                        width: SizeConfig.widthMultiplier * 1.22,
                      ),
                      Text(
                        timesheet?.breakEnd != null
                            ? DateFormat.jm().format(timesheet!.breakEnd!)
                            : '-',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
  
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            ListCardRecord(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 0.7),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translate('timesheet.shift_ended_at')}:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        timesheet?.shiftEnd != null
                            ? DateFormat.jm().format(timesheet!.shiftEnd!)
                            : '-',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
  
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListCardRecord(
              padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 0.7),
              last: true,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translate('timesheet.total_time')}:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        timesheet?.shiftEnd != null && timesheet?.shiftStart != null
                            ? totalTime(timesheet?.shiftEnd, timesheet?.shiftStart)
                            : '-',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
