import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/job_card.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:piiprent/widgets/timesheet_card.dart';
import 'package:provider/provider.dart';

class CandidateNotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobOfferService jobOfferService = Provider.of<JobOfferService>(context);
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:
            getCandidateAppBar(translate('page.title.notifications'), context,
                tabs: [
                  Tab(
                    child: Row(
                      children: [
                        Icon(
                          color: Colors.white,
                          Icons.local_offer,
                          size: SizeConfig.heightMultiplier * 3.66,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            //horizontal: 8.0,
                            horizontal:SizeConfig.widthMultiplier*1.95,
                          ),
                          child: Text(
                            translate('page.title.job_offers'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.heightMultiplier*2.34,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Icon(
                          Icons.query_builder,
                          size: SizeConfig.heightMultiplier * 3.66,
                        ),
                        Padding(
                          padding:EdgeInsets.symmetric(
                            //horizontal: 8.0,
                            horizontal:SizeConfig.widthMultiplier*1.95,
                          ),
                          child: Text(
                            translate('page.title.timesheets'),
                            style: TextStyle(
                            fontSize: SizeConfig.heightMultiplier*2.34,
                          ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                showNotification: false,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        size: SizeConfig.heightMultiplier * 5.27,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    );
                  },
                )
                ),
        body: TabBarView(
          children: [
            ListPage<JobOffer>(
              action: jobOfferService.getCandidateJobOffers,
              getChild: (JobOffer instance, Function reset) {
                return JobCard(
                  jobOffer: instance,
                  offer: true,
                  update: reset,
                );
              }, params: {}, updateStream: null,
            ),
            ListPage<Timesheet>(
              action: timesheetService.getNotificationTimesheets,
              getChild: (Timesheet instance, Function reset) {
                return TimesheetCard(
                  company: instance.company!,
                  position:
                      instance.position(localizationDelegate.currentLocale),
                  clientContact: instance.clientContact!,
                  jobsite: instance.jobsite!,
                  address: instance.address!,
                  shiftDate: instance.shiftStart!,
                  shiftStart: instance.shiftStart!,
                  shiftEnd: instance.shiftEnd!,
                  breakStart: instance.breakStart!,
                  breakEnd: instance.breakEnd!,
                  status: instance.status!,
                  id: instance.id!,
                  update: reset, timezone: '', positionId: '', clientId: '', candidateId: '',
                );
              }, params: {}, updateStream: null,
            )
          ],
        ),
      ),
    );
  }
}
