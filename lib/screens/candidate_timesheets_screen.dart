import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:piiprent/widgets/timesheet_card.dart';
import 'package:provider/provider.dart';

class CandidateTimesheetsScreen extends StatelessWidget {
  final StreamController _updateStream = StreamController();

  @override
  Widget build(BuildContext context) {
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: getCandidateAppBar(translate('page.title.timesheets'), context, tabs: [], leading: null, iconTheme: IconThemeData(color: Colors.white)),
        drawer: CandidateDrawer(),

        // Filter button on the bottom-right corner. Not needed but if there are demands of users wanting to use filter, uncomment the below code
        // floatingActionButton: FilterDialogButton(
        //   onClose: (data) {
        //     _updateStream.add({
        //       "shift_started_at_0": data['from'],
        //       "shift_started_at_1": data['to'],
        //     });
        //   },
        // ),
        body: ListPage<Timesheet>(
          action: timesheetService.getCandidateTimesheets,
          updateStream: _updateStream.stream,
          getChild: (Timesheet instance, Function reset) {

            return TimesheetCard(
              company: instance.company!,
              position: instance.position(localizationDelegate.currentLocale),
              clientContact: instance.clientContact!,
              jobsite: instance.jobsite!,
              address: instance.address!,
              shiftDate: instance.shiftStart,
              shiftStart: instance.shiftStart,
              shiftEnd: instance.shiftEnd,
              breakStart: instance.breakStart,
              breakEnd: instance.breakEnd,
              timezone: instance.timezone!,
              status: instance.status!,
              id: instance.id!,
              update: reset,
              positionId: instance.positionId!,
              clientId: instance.clientId!,
              candidateId: instance.candidateId!,
            );
          }, params: {},
        ),
      ),
    );
  }
}
