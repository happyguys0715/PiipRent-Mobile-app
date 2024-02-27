import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/job_card.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:piiprent/widgets/size_config.dart';

class CandidateJobOffersScreen extends StatelessWidget {
  static final String name = '/candidate_job_offers';

  @override
  Widget build(BuildContext context) {
    JobOfferService jobOfferService = Provider.of<JobOfferService>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: getCandidateAppBar(translate('page.title.job_offers'), context, tabs: [],leading: null, iconTheme: IconThemeData(color: Colors.white)),
        drawer: CandidateDrawer(),
        body: ListPage<JobOffer>(
          action: jobOfferService.getCandidateJobOffers,
          getChild: (JobOffer instance, Function reset) {
            return JobCard(
              jobOffer: instance,
              offer: true,
              update: reset,
            );
          }, params: {}, updateStream: null,
        ),
      ),
    );
  }
}
