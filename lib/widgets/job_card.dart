import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/screens/candidate/candidate_home_screen.dart';
import 'package:piiprent/screens/candidate_job_details_screen.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/notification_service.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/list_card.dart';
import 'package:piiprent/widgets/list_card_record.dart';
import 'package:piiprent/widgets/size_config.dart';

class JobCard extends StatefulWidget {
  final Function? update;
  final JobOffer? jobOffer;

  final bool? offer;

  JobCard({
    this.offer = false,
    this.update,
    this.jobOffer,
  });

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool _fetching = false;

  _acceptJobOffer(JobOfferService jobOfferService,
      NotificationService notificationService) async {
    setState(() {
      _fetching = true;
    });
    try {
      bool accept = await jobOfferService.accept(widget.jobOffer!.id!);
      await notificationService.checkJobOfferNotifications();
      if (accept) {
        Get.offAll(()=>CandidateHomeScreen());
      }
      if (widget.update != null) {
        widget.update!();
      }

    } catch (e) {
      print(e);
      setState(() {
        _fetching = false;
      });
    }
  }

  _declineJobOffer(JobOfferService jobOfferService,
      NotificationService notificationService) async {
    setState(() {
      _fetching = true;
    });
    try {
      await jobOfferService.decline(widget.jobOffer!.id!);
      await notificationService.checkJobOfferNotifications();

      if (widget.update != null) {
        widget.update!();
      }
    } catch (e) {
      print(e);
      setState(() {
        _fetching = false;
      });
    }
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    JobOfferService jobOfferService = Provider.of<JobOfferService>(context);
    NotificationService notificationService =
    Provider.of<NotificationService>(context);

    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  CandidateJobDetailsScreen(
                    jobOffer: widget.jobOffer,
                  ),
            ),
          ),
      child: ListCard(
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.jobOffer!.company!,
              style: TextStyle(
                //fontSize: 22.0,
                fontSize: SizeConfig.heightMultiplier * 3.22,
                color: Colors.white,
              ),
            ),
            Text(
              widget.jobOffer!.position!,
              style: TextStyle(
                //fontSize: 16.0,
                fontSize: SizeConfig.heightMultiplier * 2.34,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            ListCardRecord(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.blue,
                        size: SizeConfig.heightMultiplier * 3.66,
                      ),
                      SizedBox(
                        //width: 5.0,
                        width: SizeConfig.widthMultiplier * 1.22,
                      ),
                      Text(
                        DateFormat.jm().format(widget.jobOffer!.datetime!),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: Colors.blue,
                        size: SizeConfig.heightMultiplier * 3.66,
                      ),
                      SizedBox(
                        //width: 5.0,
                        width: SizeConfig.widthMultiplier * 1.22,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(widget.jobOffer!.datetime!),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  ),
                ],
              ), padding: EdgeInsets.all(0.0),
            ),
            ListCardRecord(
              last: true,
              content: Container(
                // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: SizeConfig.heightMultiplier * 3.66,
                    ),
                    SizedBox(
                      width: Get.width - 90,
                      child: Text(
                        widget.jobOffer!.location!,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ),
                  ],
                ),
              ), padding: EdgeInsets.all(0.0),
            ),
            widget!.offer!
                ? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1.0,
                          color: Colors.blue,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        //top: 10.0,
                        top: SizeConfig.heightMultiplier * 1.46,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FormSubmitButton(
                            label: translate('button.accept'),
                            onPressed: () {
                              index = 1;
                              setState(() {});
                              return _acceptJobOffer(
                                jobOfferService,
                                notificationService,
                              );
                            },
                            disabled: (_fetching && index == 1),
                            color: (Colors.green[400])!,
                            //horizontalPadding: 20,
                            horizontalPadding: SizeConfig.widthMultiplier *
                                4.86,
                          ),
                          FormSubmitButton(
                            label: translate('button.reject'),
                            onPressed: () {
                              index = 2;
                              setState(() {});
                              return _declineJobOffer(
                                jobOfferService,
                                notificationService,
                              );
                            },
                            disabled: (_fetching && index == 2),
                            color: (Colors.red[400])!,
                            //horizontalPadding: 20,
                            horizontalPadding: SizeConfig.widthMultiplier *
                                4.86,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
