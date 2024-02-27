import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/models/jobsite_model.dart';
import 'package:piiprent/services/jobsite_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/client_app_bar.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/jobsite_card.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:provider/provider.dart';

class ClientJobsitesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobsiteService jobsiteService = Provider.of<JobsiteService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    return DefaultTabController(
      length: 0,
      child: Scaffold(
        appBar: getClientAppBar(translate('page.title.jobsites'), context, tabs: [], leading: null, iconTheme: IconThemeData(color: Colors.white)),
        drawer: ClientDrawer(),
        body: ListPage<Jobsite>(
          action: jobsiteService.getJobsites,
          params: {
            'role': loginService.user?.roles?[
                Provider.of<LoginProvider>(context, listen: false).switchRole].id,
          },
          getChild: (Jobsite instance, Function reset) {
            return JobsiteCard(
              jobsite: instance, update: null,
            );
          }, updateStream: null,
        ),
      ),
    );
  }
}
