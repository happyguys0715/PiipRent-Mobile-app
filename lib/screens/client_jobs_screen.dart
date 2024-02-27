import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/models/job_model.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/widgets/client_app_bar.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/client_job_card.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:provider/provider.dart';

class ClientJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobService jobService = Provider.of<JobService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    return DefaultTabController(
      length: 0,
      child: Scaffold(
        appBar: getClientAppBar(translate('page.title.jobs'), context, tabs: [], leading: null, iconTheme: IconThemeData(color: Colors.white)),
        drawer: ClientDrawer(),
        body: SafeArea(
          child: ListPage<Job>(
            action: jobService.getClientJobs,
            params: {
              'role': loginService.user?.roles?[Provider.of<LoginProvider>(context).switchRole].id,
            },
            getChild: (Job instance, Function reset) {
              return ClientJobCard(
                job: instance,
              );
            }, updateStream: null,
          ),
        ),
      ),
    );
  }
}
