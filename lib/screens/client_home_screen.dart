import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/widgets/client_app_bar.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/home_calendar.dart';
import 'package:piiprent/widgets/home_screen_button.dart';
import 'package:piiprent/widgets/page_container.dart';
import '../widgets/size_config.dart';

class ClientHomeScreen extends StatefulWidget {
  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints = BoxConstraints(maxHeight: size.height,maxWidth: size.width,);
    SizeConfig().init(constraints, orientation);

    return DefaultTabController(
      length: 0,
      child: Scaffold(
        drawer: ClientDrawer(dashboard: true),
        appBar: getClientAppBar(translate('page.title.dashboard'), context, tabs: [], leading: null, iconTheme: IconThemeData(color: Colors.white)),
        body: SafeArea(
          child: PageContainer(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: HomeScreenButton(
                          color: Colors.blue[700],
                          icon: Icon(
                            Icons.checklist,
                            color: Colors.blue[700],
                          ),
                          //path: '/candidate_profile',
                          path: '',
                          text: translate('page.title.inventory'), stream: null, update: null,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: HomeScreenButton(
                          color: Colors.orange[700],
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.orange[700],
                          ),
                          path: '/client_jobsites',
                          text: translate('page.title.jobsites'), stream: null, update: null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: HomeScreenButton(
                          color: Colors.amber[700],
                          icon: Icon(
                            Icons.business_center,
                            color: Colors.amber[700],
                          ),
                          path: '/client_jobs',
                          text: translate('page.title.jobs'), stream: null, update: null,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: HomeScreenButton(
                          color: Colors.green[700],
                          icon: Icon(
                            Icons.query_builder,
                            color: Colors.green[700],
                          ),
                          path: '/client_timesheets',
                          text: translate('page.title.timesheets'), stream: null, update: null,
                        ),
                      )
                    ],
                  ),
                  HomeCalendar(
                    type: CalendarType.Client, userId: '', candidateId: '',
                  // role: loginService.user!=null ? loginService.user.activeRole.id : '',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
