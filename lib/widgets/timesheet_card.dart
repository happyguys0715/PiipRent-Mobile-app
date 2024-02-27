import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/screens/timesheets_details/candidate_timesheet_new_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';
import 'package:piiprent/widgets/size_config.dart';

class TimesheetCard extends StatelessWidget {
  final String? company;
  final String? position;
  final String? clientContact;
  final String? address;
  final String? jobsite;
  final DateTime? shiftDate;
  final DateTime? shiftStart;
  final DateTime? shiftEnd;
  final DateTime? breakStart;
  final DateTime? breakEnd;
  final String? timezone;
  final int? status;
  final String? id;
  final Function? update;
  final String? positionId;
  final String? clientId;
  final String? candidateId;

  TimesheetCard(
      {this.company,
      this.position,
      this.clientContact,
      this.address,
      this.jobsite,
      this.shiftDate,
      this.shiftStart,
      this.shiftEnd,
      this.breakStart,
      this.breakEnd,
      this.timezone,
      this.status,
      this.id,
      this.update,
      this.positionId,
      this.clientId,
      this.candidateId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => CandidateTimesheetNewDetailsScreen(
              position: position,
              jobsite: jobsite,
              name: clientContact,
              address: address,
              shiftDate: shiftDate,
              shiftStart: shiftStart,
              shiftEnd: shiftEnd,
              breakStart: breakStart,
              breakEnd: breakEnd,
              timezone: timezone,
              status: status,
              id: id,
              positionId: positionId,
              companyId: clientId,
              candidateId: candidateId,
              companyStr: company,
            ),
          ),
        );

        if (result!) {
          update!();
        }
      },
      child: ListCard(
        header: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        //4.0,
                        SizeConfig.heightMultiplier * 0.58,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(
                    //4.0,
                    SizeConfig.heightMultiplier * 0.58,
                  ),
                  margin: EdgeInsets.only(
                    //4.0,
                    bottom: SizeConfig.heightMultiplier * 0.58,
                  ),
                  child: Text(
                    '${translate(TimesheetStatus[status]!)}',
                    style: TextStyle(
                      //fontSize: 16.0,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                      color: status == 3 ? Colors.red[300] : Colors.green[300],
                    ),
                  ),
                ),
                Text(
                  company!,
                  style: TextStyle(
                    //fontSize: 22.0,
                    fontSize: SizeConfig.heightMultiplier * 3.22,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width -
                      (SizeConfig.widthMultiplier * 17.52),
                  child: Text(
                    clientContact!,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white, //fontSize: 16.0,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      //size: 16.0,
                      size: SizeConfig.heightMultiplier * 2.34,
                    ),
                    SizedBox(
                      //width: 5.0,
                      width: SizeConfig.widthMultiplier * 1.22,
                    ),
                    FittedBox(
                      child: Text(
                        address!,
                        style: TextStyle(
                          color: Colors.white, //fontSize: 16.0,
                          // fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
        body: Column(
          children: [
            ListCardRecord(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate('timesheet.shift_started_at'),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(shiftDate!),
                        style: TextStyle(
                          color: Colors.black, //fontSize: 16.0,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      SizedBox(
                        //width: 5.0,
                        width: SizeConfig.widthMultiplier * 1.22,
                      ),
                      Text(
                        DateFormat.jm().format(shiftStart!),
                        style: TextStyle(
                          color: Colors.black, //fontSize: 16.0,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      )
                    ],
                  )
                ],
              ), padding: EdgeInsets.all(10.0),
            ),
            breakStart != null || breakEnd != null
                ? ListCardRecord(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate('timesheet.break'),
                          style: TextStyle(
                            color: Colors.black, //fontSize: 16.0,
                            fontSize: SizeConfig.heightMultiplier * 2.34,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              breakStart == null
                                  ? ''
                                  : DateFormat.jm().format(breakStart!),
                              style: TextStyle(
                                color: Colors.black, //fontSize: 16.0,
                                fontSize: SizeConfig.heightMultiplier * 2.34,
                              ),
                            ),
                            SizedBox(
                              //width: 5.0,
                              width: SizeConfig.widthMultiplier * 1.22,
                            ),
                            Text(
                              translate('timesheet.break_to'),
                              style: TextStyle(
                                color: Colors.black, //fontSize: 16.0,
                                fontSize: SizeConfig.heightMultiplier * 2.34,
                              ),
                            ),
                            SizedBox(
                              //width: 5.0,
                              width: SizeConfig.widthMultiplier * 1.22,
                            ),
                            Text(
                              breakEnd == null
                                  ? ''
                                  : DateFormat.jm().format(breakEnd!),
                              style: TextStyle(
                                color: Colors.black, //fontSize: 16.0,
                                fontSize: SizeConfig.heightMultiplier * 2.34,
                              ),
                            )
                          ],
                        )
                      ],
                    ), padding: EdgeInsets.all(10.0),
                  )
                : SizedBox(),
            ListCardRecord(
              last: true,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate('timesheet.shift_ended_at'),
                    style: TextStyle(
                      color: Colors.black, //fontSize: 16.0,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  shiftEnd != null
                      ? Row(
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy').format(shiftEnd!),
                              style: TextStyle(
                                color: Colors.black, //fontSize: 16.0,
                                fontSize: SizeConfig.heightMultiplier * 2.34,
                              ),
                            ),
                            SizedBox(
                              //width: 5.0,
                              width: SizeConfig.widthMultiplier * 1.22,
                            ),
                            Text(
                              DateFormat.jm().format(shiftEnd!),
                              style: TextStyle(
                                color: Colors.black, //fontSize: 16.0,
                                fontSize: SizeConfig.heightMultiplier * 2.34,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ), padding: EdgeInsets.all(10.0),
            ),
          ],
        ),
      ),
    );
  }
}
