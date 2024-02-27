import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';
import 'package:piiprent/widgets/job_card.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:provider/provider.dart';

class CandidateJobsScreen extends StatelessWidget {
  final StreamController _updateStream = StreamController();

  @override
  Widget build(BuildContext context) {
    JobService jobService = Provider.of<JobService>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: getCandidateAppBar(translate('page.title.jobs'), context, tabs: [], leading: null, iconTheme: IconThemeData(color: Colors.white)),
        drawer: CandidateDrawer(),

        // Filter button on the bottom-right corner. Not needed but if there are demands of users wanting to use filter, uncomment the below code
        // floatingActionButton: FilterDialogButton(
        //   onClose: (data) {
        //     _updateStream.add({
        //       "shift__date__shift_date_0": data['from'],
        //       "shift__date__shift_date_1": data['to'],
        //     });
        //   },
        // ),
        body: ListPage<JobOffer>(
          action: jobService.getCandidateJobs,
          updateStream: _updateStream.stream,
          getChild: (JobOffer instance, Function reset) {
            return JobCard(
              jobOffer: instance, update: null,
            );
          }, params: {},
        ),
      ),
    );
  }
}
