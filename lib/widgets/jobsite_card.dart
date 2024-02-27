import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:piiprent/models/jobsite_model.dart';
import 'package:piiprent/screens/client_jobsite_details_screen.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';
import 'package:piiprent/widgets/size_config.dart';

class JobsiteCard extends StatelessWidget {
  final Function? update;
  final Jobsite? jobsite;

  JobsiteCard({
    this.update,
    this.jobsite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClientJobsiteDetailsScreen(
            jobsite: jobsite,
          ),
        ),
      ),
      child: ListCard(
        header: Text(
          jobsite!.company!,
          textAlign: TextAlign.center,
          style: TextStyle(
            //fontSize: 22.0,
            fontSize: SizeConfig.heightMultiplier * 3.02,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: Column(
          children: [
            ListCardRecord(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translate('job.address')}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                Container(
                  width: 200, // Set an appropriate width
                  child: Text(
                    jobsite!.address!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                ),
                  
                ],
              ), 
              padding: EdgeInsets.only(bottom: 5.0, top: 0),
            ),
            ListCardRecord(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translate('field.start_date')}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Text(
                    jobsite?.startDate != null
                        ? DateFormat('dd/MM/yyyy').format(jobsite!.startDate!)
                        : '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                ],
              ), padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
            ),
            ListCardRecord(
              last: true,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${translate('field.end_date')}:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                  Text(
                    jobsite?.endDate != null
                        ? DateFormat('dd/MM/yyyy').format(jobsite!.endDate!)
                        : '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  ),
                ],
              ), padding: EdgeInsets.only(bottom: 0, top: 5.0),
            ),
          ],
        ),
      ),
    );
  }
}
