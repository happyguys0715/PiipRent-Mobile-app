import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/client_app_bar.dart';
import 'package:piiprent/widgets/client_drawer.dart';
import 'package:piiprent/widgets/client_timesheet_card.dart';
import 'package:piiprent/widgets/filter_dialog_button.dart';
import 'package:piiprent/widgets/list_page.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

class ClientTimesheetsScreen extends StatelessWidget {
  final StreamController _updateStream = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: getClientAppBar(
          translate('page.title.timesheets'),
          context,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 1.95,
                    ),
                    child: Text(
                      translate('page.title.timesheets.unapproved'),
                      style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 2.34,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.query_builder),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 1.95,
                    ),
                    child: Text(
                      translate('page.title.timesheets.history'),
                      style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 2.34,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          leading: null,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: ClientDrawer(),

        body: TabBarView(
          children: [
            ListPage<Timesheet>(
              action: timesheetService.getUnapprovedTimesheets,
              updateStream: _updateStream.stream,
              params: {
                'role': loginService.user?.roles?[Provider.of<LoginProvider>(context).switchRole].id,
              },
              getChild: (Timesheet instance, Function reset) {
                return ClientTimesheetCard(
                  timesheet: instance,
                  update: reset,
                  unapprovedCard: true,
                );
              },
            ),
            ListPage<Timesheet>(
              action: timesheetService.getHistoryTimesheets,
              updateStream: _updateStream.stream,
              params: {
                'role':  loginService.user?.roles?[Provider.of<LoginProvider>(context).switchRole].id,
              },
              getChild: (Timesheet instance, Function reset) {
                return ClientTimesheetCard(
                  timesheet: instance,
                  update: reset,
                  unapprovedCard: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
