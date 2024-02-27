import 'dart:convert';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/notification_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/services/tracking_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/candidate_drawer.dart';
import 'package:piiprent/widgets/home_calendar.dart';
import 'package:piiprent/widgets/home_screen_button.dart';
import 'package:piiprent/widgets/page_container.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CandidateHomeScreen extends StatefulWidget {
  @override
  _CandidateHomeScreenState createState() => _CandidateHomeScreenState();
}

class _CandidateHomeScreenState extends State<CandidateHomeScreen> {
  TimesheetService _timesheetService = TimesheetService();
  TrackingService _trackingService = TrackingService();

  _getActiveTimesheet() async {
    List<Map<String, dynamic>> activeTimesheets =
        await _timesheetService.getActiveTimeheets();

    if (activeTimesheets != null && activeTimesheets.length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('activeTimesheets', json.encode(activeTimesheets));

      return activeTimesheets;
    }

    return null;
  }

  void showConcernDialog(dynamic activeTimesheets) {
    showProminentDisclosureDialog(context, (bool isAllowed) {
      if (isAllowed == true) {
        _getCurrentPosition(activeTimesheets);
      } else if (isAllowed == false) {
        showDenyAlertDialog(context, (bool isAllowed) {
          if (isAllowed == true) {
            showConcernDialog(activeTimesheets);
          }
        });
      }
    });
  }

  _getCurrentPosition(dynamic activeTimesheets) async {
    // await BackgroundLocation.setAndroidNotification(
    //   title: "Background Location Service",
    //   message: "Fetching your current location",
    //   icon: "@mipmap/ic_launcher",
    // );

    await BackgroundLocation.startLocationService(distanceFilter: 5.0);
    // Start location service here or do something else
    BackgroundLocation.getLocationUpdates((location) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String activeTimesheetsEncoded =
          (prefs.getString('activeTimesheets') ?? '');

      if (activeTimesheetsEncoded == null) {
        return;
      }

      List<dynamic> activeTimeshseets = json.decode(activeTimesheetsEncoded);

      try {
        var activeTimesheet = activeTimeshseets.firstWhere((element) {
          DateTime from = DateTime.parse(element['from']);
          DateTime newFrom = from.subtract(Duration(hours: 1));
          DateTime now = DateTime.now().toUtc();
          
          if (element['to'] == null) {
            DateTime newTo = newFrom.add(Duration(hours: 12));
            return now.isAfter(newFrom) && now.isBefore(newTo);
          } else {
            DateTime to = DateTime.parse(element['to']);
            DateTime newTo = to.add(Duration(hours: 1));
            return now.isAfter(newFrom) && now.isBefore(newTo);
          }
        });

        var result = await _trackingService.sendLocation(
          location,
          activeTimesheet['id']
        );
      } catch (e) {
        BackgroundLocation.stopLocationService();
        return null;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _getActiveTimesheet().then(showConcernDialog);
  }

  @override
  Widget build(BuildContext context) {
    NotificationService notificationService =
        Provider.of<NotificationService>(context);
    LoginService loginService = Provider.of<LoginService>(context);

    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints = BoxConstraints(
      maxHeight: size.height,
      maxWidth: size.width,
    );
    SizeConfig().init(constraints, orientation);

    return DefaultTabController(
      length: 0,
      child: Scaffold(
        drawer: CandidateDrawer(dashboard: true),
        appBar: getCandidateAppBar(translate('page.title.dashboard'), context, tabs: [], leading: null, iconTheme: IconThemeData(color: Colors.white)),
        body: SafeArea(
          child: PageContainer(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment:
                    orientation == Orientation.landscape && size.width > 1000
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                children: [
                  SizedBox(
                    //height: 26,
                    height: SizeConfig.heightMultiplier * 2.20,
                  ),
                  orientation == Orientation.landscape && size.width > 1000
                      ? Align(
                          alignment: Alignment.center,
                          child: _buildProfileRow(notificationService),
                        )
                      : _buildProfileRow(notificationService),
                  orientation == Orientation.landscape && size.width > 1000
                      ? Align(
                          alignment: Alignment.center,
                          child: _buildJobsRow(notificationService),
                        )
                      : _buildJobsRow(notificationService),
                  if (orientation == Orientation.landscape && size.width > 1000)
                    Align(
                      alignment: Alignment.center,
                      child: Container(child: _buildHomeCalendar(loginService)),
                    )
                  else
                    _buildHomeCalendar(loginService),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildProfileRow(notificationService) => Container(
    constraints: BoxConstraints(
      maxWidth: 1250,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: HomeScreenButton(
            color: (Colors.blue[700])!,
            icon: Icon(
              Icons.checklist,
              color: Colors.blue[700],
            ),
            // path: '/candidate_profile',
            path: '',
            text: translate('page.title.inventory'), stream: null, update: null,
          ),
        ),
        Expanded(
          flex: 1,
          child: HomeScreenButton(
            color: (Colors.orange[700])!,
            icon: Icon(
              Icons.local_offer,
              color: Colors.orange[700],
            ),
            path: '/candidate_job_offers',
            text: translate('page.title.job_offers'),
            stream: notificationService.jobOfferStream,
            update: notificationService.checkJobOfferNotifications,
          ),
        ),
      ],
    ),
  );

  _buildJobsRow(notificationService) => Container(
    constraints: BoxConstraints(
      maxWidth: 1250,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: HomeScreenButton(
            color: (Colors.amber[700])!,
            icon: Icon(
              Icons.business_center,
              color: Colors.amber[700],
            ),
            path: '/candidate_jobs',
            text: translate('page.title.jobs'), stream: null, update: null,
          ),
        ),
        Expanded(
          flex: 1,
          child: HomeScreenButton(
            color: (Colors.green[700])!,
            icon: Icon(
              Icons.query_builder,
              color: Colors.green[700],
            ),
            path: '/candidate_timesheets',
            text: translate('page.title.timesheets'),
            stream: notificationService.timesheetStream,
            update: notificationService.checkTimesheetNotifications,
          ),
        )
      ],
    ),
  );

  Widget _buildHomeCalendar(loginService) => HomeCalendar(
    type: CalendarType.Canddate,
    userId: loginService.user != null ? loginService.user.id : null,
    candidateId:
        loginService.user != null ? loginService.user.candidateId : null,
  );
}
