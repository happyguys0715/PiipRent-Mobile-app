import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/job_model.dart';
import 'package:piiprent/screens/client_job_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';
import 'package:piiprent/widgets/size_config.dart';

class ClientJobCard extends StatelessWidget {
  final Job? job;

  ClientJobCard({
    required this.job,
  });

  Widget _buildStatus(String label, JobStatus status) {
    IconData? icon;
    Color? color;

    // switch (status) {
    //   case JobStatus.Unfilled:
    //     {
    //       icon = Icons.close;
    //       color = Colors.red[400];
    //       break;
    //     }
    //   case JobStatus.Fullfilled:
    //     {
    //       icon = Icons.check_circle;
    //       color = Colors.green[400];
    //       break;
    //     }
    //   default:
    //     {
    //       icon = Icons.remove_circle;
    //       color = Colors.grey[400];
    //     }
    // }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 0.97,
        //horizontal:4.0,
      ),
      padding: EdgeInsets.symmetric(
        // horizontal: 8.0,
        // vertical: 4.0,
        horizontal: SizeConfig.widthMultiplier * 1.94,
        vertical: SizeConfig.textMultiplier * 0.58,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.all(
          //Radius.circular(4.0),
          Radius.circular(SizeConfig.textMultiplier * 0.58),
        ),
      ),
      child: Row(
        children: [
          Text(
            translate('timesheet.status'),
            style: TextStyle(
              //fontSize: 13,
              fontSize: SizeConfig.heightMultiplier * 1.90,
            ),
          ),
          SizedBox(
            //width: 4.0,
            width: SizeConfig.widthMultiplier * 0.97,
          ),
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
            ),
          ),
          Icon(
            icon,
            color: color,
            //size: 20.0,
            size: SizeConfig.heightMultiplier * 2.93,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClientJobDetailsScreen(
            position: job?.translations?['position']['en'],
            jobsite: job?.jobsite,
            workStartDate: job?.workStartDate,
            notes: job?.notes,
            tags: job?.tags,
            id: job?.id,
            contact: job?.contact,
            company: job?.company,
          ),
        ),
      ),
      child: Column(
        children: [
          ListCard(
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: SizeConfig.heightMultiplier * 1.0,
                  ),
                  child: Text(
                    '${job?.company}',
                    style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 3.24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // SizedBox(
                //   height: SizeConfig.heightMultiplier * 1.46,
                // ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   padding: EdgeInsets.only(
                //     left: SizeConfig.heightMultiplier * 1.0,
                //   ),
                //   child: Text(
                //     '${job?.address}',
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //       //fontSize: 18.0,
                //       fontSize: SizeConfig.textMultiplier * 2.34,
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  // child: Text(
                  //   '${job?.contact}',
                  //   style: TextStyle(
                  //     color: Colors.black87,
                  //     fontSize: SizeConfig.heightMultiplier * 2.84,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                ),
                ListCardRecord(
                  separatorColor: (Colors.grey[400])!,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${translate('page.title.jobsite')}:",
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 1.46,
                      ),
                      Expanded(
                        child: Text(
                          '${job?.jobsite}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: SizeConfig.heightMultiplier * 2.34,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ), padding: EdgeInsets.only(bottom: 5.0, top: 0.0),
                ),
                ListCardRecord(
                  separatorColor: (Colors.grey[400])!,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${translate('field.start_date')}:",
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(job!.workStartDate!),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ), padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                ),
                ListCardRecord(
                  separatorColor: (Colors.grey[400])!,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate('job.position'),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      Text(
                        job!.translations?['position']['en'],
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ), padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                ),
                ListCardRecord(
                  separatorColor: (Colors.grey[400])!,
                  last: true,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                       translate('job.employees'),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      Text(
                        job!.workers.toString(),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ), padding: EdgeInsets.only(bottom: 0.0, top: 5.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
