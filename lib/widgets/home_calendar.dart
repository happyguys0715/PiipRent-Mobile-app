import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/models/candidate_work_statistics.dart';
import 'package:piiprent/models/carrier_model.dart';
import 'package:piiprent/models/shift_model.dart';
import 'package:piiprent/screens/timesheets_details/widgets/date_picker_box_widget.dart';
import 'package:piiprent/services/candidate_service.dart';
import 'package:piiprent/services/job_service.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/timesheetView_service.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/models/role_model.dart';

enum CalendarType {
  Canddate,
  Client,
}

enum CarrrierStatus {
  Available,
  Unavailable,
}

class HomeCalendar extends StatefulWidget {
  final CalendarType type;
  final String? userId;
  // final String role;
  final String? candidateId;

  HomeCalendar({
    required this.type,
    this.userId,
    // this.role,
    this.candidateId,
  });

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  CandidateService _candidateService = CandidateService();
  TimesheetData _timesheetCounter = TimesheetData();
  LoginService _loginService = LoginService();
  JobService _jobService = JobService();
  ContactService contactService = ContactService();
  var _calendarController;

  Map<DateTime, List>? _candidateUnavailable;
  Map<DateTime, List>? _candidateAvailable;

  Map<DateTime, List<Shift>>? _clientFulfilledShifts;
  Map<DateTime, List<Shift>>? _clientUnfulfilledShifts;
  Map<DateTime, List<Shift>>? _clientPendingShifts;

  List<Shift>? _shifts;

  int currentIndex = 0;

  bool _isLoading = true;

  CandidateWorkState _candidateWorkStates = CandidateWorkState(id: '', sStr: '', shiftsTotal: null, hourlyWork: null, skillActivities: null, currency: '');

  bool _isCustomCounter = false;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  DateTime? _currentDay;

  _initCandidateCalendar() async {
    if (widget.candidateId == null) {
      return;
    }

    var data = await _candidateService.getStatistics(
        contactId: widget.candidateId!,
        startedAt0: DateTime.now(),
        startedAt1: DateTime.now());
    if (data != null) {
      _candidateWorkStates =
          CandidateWorkState.fromJson(json.decode(data.body));
    }

    // var jobOffers = await _timesheetCounter.getJobOffers(
    //     contactId: widget.candidateId!,
    //     startedAt0: DateTime.now(),
    //     startedAt1: DateTime.now());
    // if (jobOffers != null) {
      
    //   // var jobOfferStatus =
    //   //     await _timesheetCounter.fromJsonJobOffers(json.decode(jobOffers.body));
    // }

    // var timeSheets = await _timesheetCounter.getTimeSheet(
    //     contactId: widget.candidateId!,
    //     startedAt0: DateTime.now(),
    //     startedAt1: DateTime.now(),
    //     role: "candidate");
    // if (timeSheets != null) {
    //   var timesheetStatus =
    //      await _timesheetCounter.fromJsonTimeSheet(json.decode(timeSheets.body));
    // }

    try {
      List<Carrier> carriers =
          await _candidateService.getCandidateAvailability(widget.userId!) as List<Carrier>;

      _candidateAvailable = {};
      _candidateUnavailable = {};

      setState(() {
        carriers.forEach((Carrier el) {
          if (el.confirmedAvailable!) {
            _candidateAvailable?.addAll({
              el.targetDateUtc!: [el]
            });
          } else {
            _candidateUnavailable?.addAll({
              el.targetDateUtc!: [el]
            });
          }
        });
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  _initCandidateCounter() async {
    var timeSheets = await _timesheetCounter.getTimeSheet(
        contactId: widget.candidateId!,
        startedAt0: DateTime.now(),
        startedAt1: DateTime.now(),
        role: "candidate");
    if (timeSheets != null) {
      _timesheetCounter.fromJsonTimeSheet(json.decode(timeSheets.body));
    }

      setState(() {
        _isLoading = false;
      });
  }

  _initClientCalendar() async {
    try {
      List<Role> roles = await contactService.getRoles();
      List<Shift> shifts = await _jobService.getClientShifts({
        'role': roles[0].id,
      });
      var data = await _candidateService.getStatistics(
          contactId: widget.userId!,
          startedAt0: DateTime.now(),
          startedAt1: DateTime.now());
      if (data != null) {
        _candidateWorkStates =
            CandidateWorkState.fromJson(json.decode(data.body));
      }

      // var timeSheets = await _timesheetCounter.getTimeSheet(
      //   contactId: widget.candidateId!,
      //   startedAt0: DateTime.now(),
      //   startedAt1: DateTime.now(),
      //   role: "client");
      // if (timeSheets != null) {
      //   var timesheetStatus =
      //     await _timesheetCounter.fromJsonTimeSheet(json.decode(timeSheets.body));
      // }
      _clientFulfilledShifts = {};
      _clientUnfulfilledShifts = {};
      _clientPendingShifts = {};

      setState(() {
        shifts.forEach((Shift el) {
          if (el.isFulfilled!) {
            _clientFulfilledShifts?.addAll({
              el.date!: [el]
            });
          } else if (el.pending!) {
            _clientPendingShifts?.addAll({
              el.date!: [el]
            });
          } else {
            _clientUnfulfilledShifts?.addAll({
              el.date!: [el]
            });
          }
        });
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // _calendarController = CalendarController();
    currentIndex = 3;
    _currentDay = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (widget.type == CalendarType.Canddate) {
      _initCandidateCalendar();
      _initCandidateCounter();
    }

    if (widget.type == CalendarType.Client) {
      _initClientCalendar();
      _shifts = [];
    }
  }

  @override
  void dispose() {
    if (_calendarController != null) {
      _calendarController.dispose();
    }
    super.dispose();
  }

  _updateAvailability(
    DateTime date,
    CarrrierStatus status,
    String id,
  ) async {
    if (status.runtimeType != CarrrierStatus) {
      return;
    }

    if (id == null) {
      try {
        Carrier carrier = await _candidateService.setAvailability(
            date, status == CarrrierStatus.Available, widget.userId!) as Carrier;

        if (carrier != null) {
          setState(() {
            if (status == CarrrierStatus.Available) {
              _candidateAvailable?[date] = [carrier];
            } else {
              _candidateUnavailable?[date] = [carrier];
            }
          });
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        Object carrier = await _candidateService.updateAvailability(
          date,
          status == CarrrierStatus.Available,
          widget.userId!,
          id,
        );

        if (carrier != null) {
          setState(
            () {
              if (status == CarrrierStatus.Available) {
                _candidateAvailable?[date] = [carrier];
                _candidateUnavailable?.removeWhere(
                  (key, value) => key.toString() == date.toString(),
                );
              } else {
                _candidateAvailable?.removeWhere(
                  (key, value) => key.toString() == date.toString(),
                );
                _candidateUnavailable?[date] = [carrier];
              }
            },
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  List<String> counterButtons = [
    'counterbutton.last_month',
    'counterbutton.this_month',
    'counterbutton.this_week',
    'counterbutton.today',
    'counterbutton.this_year',
    'counterbutton.custom',
  ];

  Widget _buildCandidateCalendar(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          TableCalendar(
            daysOfWeekHeight: SizeConfig.heightMultiplier * 4.39,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.04,
              ),
              weekendStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.04,
                color: Colors.red[400],
              ),
            ),
            availableGestures: AvailableGestures.none,
            //  simpleSwipeConfig: const SimpleSwipeConfig(
            //   verticalThreshold: 25.0,
            //   swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
            // ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              disabledTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              outsideTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              selectedTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              weekendTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
                color: Colors.red[500],
              ),
            ),
            headerStyle: HeaderStyle(
              leftChevronMargin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 4.87,
              ),
              rightChevronMargin: EdgeInsets.only(
                right: SizeConfig.widthMultiplier * 4.87,
              ),
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.84,
              ),
              leftChevronIcon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: SizeConfig.heightMultiplier * 2.56,
              ),
              rightChevronIcon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: SizeConfig.heightMultiplier * 2.56,
              ),
            ),
            // calendarFormat: CalendarFormat.month,
            //rowHeight: 40,
            rowHeight: SizeConfig.heightMultiplier * 5.87,
            //todo: revert to one month later for ruslanzaharov1105@gmail.com, later remove it
            focusedDay: _currentDay!,
            firstDay: DateTime.now().subtract(
              Duration(
                days: 365,
              ),
            ),
            lastDay: Jiffy.now().add(years: 1).dateTime,
            currentDay: _currentDay,

            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (date, events) {
              String? id;
              if (_candidateAvailable != null) {
                id = _candidateAvailable?[date] != null
                    ? _candidateAvailable![date]![0].id
                    : null;
              }
              _currentDay = date;
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  actions: [
                    InkWell(
                      onTap: _candidateAvailable?[date] == null
                          ? () {
                              Navigator.of(context)
                                  .pop(CarrrierStatus.Available);
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                        padding: EdgeInsets.all(
                          //12,
                          SizeConfig.heightMultiplier * 1.76,
                        ),
                        child: Text(
                          translate('button.available'),
                          style: TextStyle(
                            color: Colors.white,
                            //fontSize: 14,
                            fontSize: SizeConfig.heightMultiplier * 2.04,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _candidateUnavailable?[date] == null
                          ? () {
                              Navigator.of(context)
                                  .pop(CarrrierStatus.Unavailable);
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.all(
                          //12,
                          SizeConfig.heightMultiplier * 1.76,
                        ),
                        child: Text(
                          translate('button.unavailable'),
                          style: TextStyle(
                            color: Colors.white,
                            //fontSize: 14,
                            fontSize: SizeConfig.heightMultiplier * 2.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                  title: Text(id != null
                      ? translate('dialog.update')
                      : translate('dialog.confirm')),
                  contentPadding: EdgeInsets.all(
                    //8.0
                    SizeConfig.heightMultiplier * 1.17,
                  ),
                  titlePadding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.heightMultiplier * 1.95,
                    vertical: SizeConfig.heightMultiplier * 1.46,
                    // horizontal: 8.0,
                    // vertical: 10.0,
                  ),
                ),
              ).then((available) => _updateAvailability(date, available, id!));
            },
            calendarBuilders: CalendarBuilders(
              todayBuilder:
                  (BuildContext context, DateTime day, DateTime focusedDay) =>
                      Container(
                height: SizeConfig.heightMultiplier * 6.59,
                width: SizeConfig.widthMultiplier * 10.95,
                // height: 45,
                // width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withOpacity(0.6),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              outsideBuilder:
                  (BuildContext context, DateTime day, DateTime focusedDay) =>
                      SizedBox(),
              disabledBuilder:
                  (BuildContext context, DateTime day, DateTime focusedDay) =>
                      day.month == DateTime.now().month ? null : SizedBox(),
              markerBuilder: (context, date, events) {
                if (_candidateAvailable != null) {
                  if (_candidateAvailable?[date] != null) {
                    return Positioned(
                      //bottom: 2,
                      bottom: SizeConfig.heightMultiplier * 0.29,
                      child: _buildRectangle(
                        width: SizeConfig.widthMultiplier * 1.5, // Define the width as needed
                        height: SizeConfig.heightMultiplier * 1, // Define the height as needed
                        color: Colors.green[400]!,
                      ),
                    );
                  }
                }

                if (_candidateUnavailable != null) {
                  if (_candidateUnavailable?[date] != null) {
                    return Positioned(
                      //bottom: 2,
                      bottom: SizeConfig.heightMultiplier * 0.29,
                      child: _buildRectangle(
                        width: SizeConfig.widthMultiplier * 1.5, // Define the width as needed
                        height: SizeConfig.heightMultiplier * 1, // Define the height as needed
                        color: Colors.red[400]!,
                      ),
                    );
                  }
                }

                return SizedBox();
              },
            ),
          ),
          _buildCandidateLegend(),
          _buildTimesheetCounter(),
          SizedBox(
            //height: 10,
            height: SizeConfig.heightMultiplier * 1.46,
          ),
          Material(
            color: Colors.grey[100],
            //elevation: 3,
            //elevation: SizeConfig.heightMultiplier * 0.44,
            child: Padding(
              //padding: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(SizeConfig.heightMultiplier * 1.17),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 10,
                        //runSpacing: SizeConfig.heightMultiplier * 1.46,
                        children: [
                          ...List.generate(
                            counterButtons.length,
                            (index) => CounterButton(
                              index: index,
                              last: counterButtons.length - 1,
                              title: translate(counterButtons[index]),
                              onTapped: currentIndex == index,
                              onPressed: () async {
                                setState(() {
                                  currentIndex = index;
                                  _isLoading = true;
                                  _isCustomCounter = false;
                                });
                                if (index == 5) {
                                  setState(() {
                                    _isCustomCounter = true;
                                  });
                                }
                                if (!_isCustomCounter) {
                                  await _calculateEarning(index);
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                            )
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      //height: 20,
                      height: SizeConfig.heightMultiplier * 2.93,
                    ),
                    _buildCustomDate(),
                    SizedBox(
                      //height: 20,
                      height: SizeConfig.heightMultiplier * 2.93,
                    ),
                    if (_isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(
                          //horizontal: 15.0,
                          horizontal: SizeConfig.widthMultiplier * 3.65,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildReportHeader(),
                            SizedBox(
                              //height: 10,
                              height: SizeConfig.heightMultiplier * 1.46,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  // flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translate('table.hourly'),
                                          style: TextStyle(
                                            //fontSize: 14,
                                            fontSize:
                                                SizeConfig.heightMultiplier * 2.05,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        if (_candidateWorkStates.fiboBauroc != null)
                                          Text(
                                            translate('table.fibo.bauroc'),
                                            style: TextStyle(
                                              //fontSize: 14,
                                              fontSize:
                                                  SizeConfig.heightMultiplier * 2.05,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        if (_candidateWorkStates.baurocElement != null)
                                          Text(
                                            translate('table.bauroc.element'),
                                            style: TextStyle(
                                              //fontSize: 14,
                                              fontSize:
                                                  SizeConfig.heightMultiplier * 2.05,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        if (_candidateWorkStates.decorative != null)
                                          Text(
                                            translate('table.decorative'),
                                            style: TextStyle(
                                              //fontSize: 14,
                                              fontSize:
                                                  SizeConfig.heightMultiplier * 2.05,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                      ],)
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '${(_candidateWorkStates.hourlyWork?.totalHours ?? 0).toInt()}h ${_candidateWorkStates.hourlyWork?.totalMinutes ?? 0}m',
                                        style: TextStyle(
                                          //fontSize: 14,
                                          fontSize:
                                              SizeConfig.heightMultiplier * 2.05,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      if (_candidateWorkStates.fiboBauroc != null)
                                        Text(
                                          '${(_candidateWorkStates.fiboBauroc?.amount ?? 0).toInt()} m2',
                                          style: TextStyle(
                                            //fontSize: 14,
                                            fontSize:
                                                SizeConfig.heightMultiplier * 2.05,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      if (_candidateWorkStates.baurocElement != null)
                                        Text(
                                          '${(_candidateWorkStates.baurocElement?.amount ?? 0).toInt()} m2',
                                          style: TextStyle(
                                            //fontSize: 14,
                                            fontSize:
                                                SizeConfig.heightMultiplier * 2.05,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      if (_candidateWorkStates.decorative != null)
                                        Text(
                                          '${(_candidateWorkStates.decorative?.amount ?? 0).toInt()} m2',
                                          style: TextStyle(
                                            //fontSize: 14,
                                            fontSize:
                                                SizeConfig.heightMultiplier * 2.05,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                  ],)
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${_candidateWorkStates.hourlyWork?.totalEarned != null ? _candidateWorkStates.hourlyWork?.totalEarned!.toStringAsFixed(2) : 0} ${_candidateWorkStates.currency?.toUpperCase()}',
                                        style: TextStyle(
                                          //fontSize: 14,
                                          fontSize:
                                              SizeConfig.heightMultiplier * 2.05,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (_candidateWorkStates.fiboBauroc != null)
                                        Text(
                                          '${_candidateWorkStates.fiboBauroc?.totalEarned != null ? _candidateWorkStates.fiboBauroc?.totalEarned!.toStringAsFixed(2) : 0} ${_candidateWorkStates.currency?.toUpperCase()}',
                                          style: TextStyle(
                                            //fontSize: 14,
                                            fontSize:
                                                SizeConfig.heightMultiplier * 2.05,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      if (_candidateWorkStates.baurocElement != null)
                                        Text(
                                          '${_candidateWorkStates.baurocElement?.totalEarned != null ? _candidateWorkStates.baurocElement?.totalEarned!.toStringAsFixed(2) : 0} ${_candidateWorkStates.currency?.toUpperCase()}',
                                          style: TextStyle(
                                            //fontSize: 14,
                                            fontSize:
                                                SizeConfig.heightMultiplier * 2.05,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      if (_candidateWorkStates.decorative != null)
                                        Text(
                                          '${_candidateWorkStates.decorative?.totalEarned != null ? _candidateWorkStates.decorative?.totalEarned!.toStringAsFixed(2) : 0} ${_candidateWorkStates.currency?.toUpperCase()}',
                                          style: TextStyle(
                                            //fontSize: 14,
                                            fontSize:
                                                SizeConfig.heightMultiplier * 2.05,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),                                      
                                    ],)
                                ),
                              ],
                            ),
                            SizedBox(
                              //height: 10,
                              height: SizeConfig.heightMultiplier * 1.46,
                            ),
                            calculateTotal(),
                            SizedBox(
                              //height: 20,
                              height: SizeConfig.heightMultiplier * 2.93,
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReportHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                translate('table.activity'),
                style: TextStyle(
                  //fontSize: 14,
                  fontSize: SizeConfig.heightMultiplier * 2.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            // flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                translate('table.amount'),
                style: TextStyle(
                  //fontSize: 14,
                  fontSize: SizeConfig.heightMultiplier * 2.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            // flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                translate('table.earned'),
                style: TextStyle(
                  //fontSize: 14,
                  fontSize: SizeConfig.heightMultiplier * 2.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
  Widget calculateTotal() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${translate('table.shifts')}: ${_candidateWorkStates.shiftsTotal != null ? _candidateWorkStates.shiftsTotal : 0}',
                style: TextStyle(
                  //fontSize: 14,
                  fontSize: SizeConfig.heightMultiplier * 2.05,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              // padding: EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              child: Text(
                '${
                  translate('table.total')
                }:  ${((_candidateWorkStates.hourlyWork?.totalEarned ?? 0) + (_candidateWorkStates.skillActivities?.totalEarned ?? 0)).toStringAsFixed(2)}  ${_candidateWorkStates.currency?.toUpperCase()}'
                ,
                style: TextStyle(
                  //fontSize: 14,
                  fontSize: SizeConfig.heightMultiplier * 2.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );

  // Widget _buildClientLegend() {
  //   var data = [
  //     {
  //       'color': Colors.green[400],
  //       'label': translate('button.available'),
  //     },
  //     {
  //       'color': Colors.red[400],
  //       'label': translate('button.unavailable'),
  //     }
  //   ];
  //
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       // horizontal: 20.0,
  //       // vertical: 20.0,
  //       vertical: SizeConfig.heightMultiplier * 2.93,
  //       horizontal: SizeConfig.widthMultiplier * 4.87,
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: data
  //           .map(
  //             (el) => Row(
  //               children: [
  //                 _buildCircle(
  //                   //radius: 8.0,
  //                   radius: SizeConfig.heightMultiplier * 1.17,
  //                   color: el['color'],
  //                 ),
  //                 SizedBox(
  //                   //width: 8.0,
  //                   width: SizeConfig.widthMultiplier * 1.95,
  //                 ),
  //                 Text(
  //                   translate(el['label']),
  //                   style: TextStyle(
  //                     //fontSize: 16.0,
  //                     fontSize: SizeConfig.heightMultiplier * 2.34,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           )
  //           .toList(),
  //     ),
  //   );
  // }

  Widget _buildCandidateLegend() {
    var data = [
      {
        'color': Colors.green[400],
        'label': 'button.available',
      },
      {
        'color': Colors.red[400],
        'label': 'button.unavailable',
      }
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: 20.0,
        // vertical: 20.0,
        horizontal: SizeConfig.widthMultiplier * 4.87,
        vertical: SizeConfig.heightMultiplier * 2.93,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: data
            .map(
              (el) => Row(
                children: [
                  _buildRectangle(
                    width: SizeConfig.widthMultiplier * 1.5, // Define the width as needed
                    height: SizeConfig.heightMultiplier * 1, // Define the height as needed
                    color: el['color'] as Color,
                  ),
                  SizedBox(
                    //width: 8.0,
                    width: SizeConfig.widthMultiplier * 1.95,
                  ),
                  Text(
                    translate(el['label'] as String),
                    style: TextStyle(
                      //fontSize: 16.0,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTimesheetCounter() {

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 4.87,
        vertical: SizeConfig.heightMultiplier * 2.93,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _timesheetCounter.timesheetCounterCandidate
            .map(
              (el) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      _buildRectangle(
                        width: SizeConfig.widthMultiplier * 1.5, // Define the width as needed
                        height: SizeConfig.heightMultiplier * 1, // Define the height as needed
                        color: el.color,
                      ),
                      SizedBox(
                        //width: 8.0,
                        width: SizeConfig.widthMultiplier * 1.95,
                      ),
                      Text(
                        translate(el.count.toString()),
                        style: TextStyle(
                          //fontSize: 16.0,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ],
                  ),                  
                  Text(
                    translate(el.text),
                    style: TextStyle(
                      //fontSize: 16.0,
                      fontSize: SizeConfig.heightMultiplier * 2.34,
                    ),
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRectangle({required double width, required double height, required Color color}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }

  Widget _buildTableCell(String text, [Color color = Colors.black]) {
    return Padding(
      //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier * 1.17,
        horizontal: SizeConfig.widthMultiplier * 0.97,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          //fontSize: 16.0,
          fontSize: SizeConfig.heightMultiplier * 2.34,
        ),
      ),
    );
  }

  Widget _buildTable(List<Shift> data) {
    if (data.length == 0) {
      return SizedBox();
    }

    List<Shift> body = [];
    body.add(data[0]);
    data.forEach((shift) => body.add(shift));

    return Column(
      children: [
        Container(
          //padding: const EdgeInsets.symmetric(vertical: 6.0),
          //margin: const EdgeInsets.only(top: 14.0),
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier * 0.87,
          ),
          margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 2.05,
          ),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            translate('table.shifts'),
            style: TextStyle(
              //fontSize: 16.0,
              fontSize: SizeConfig.heightMultiplier * 2.34,
              color: Colors.black,
            ),
          ),
        ),
        Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Colors.grey,
            ),
          ),
          children: body.asMap().entries.map((e) {
            int i = e.key;
            Shift shift = e.value;

            if (i == 0) {
              return TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: [
                  _buildTableCell(translate('field.jobsite')),
                  _buildTableCell(translate('field.start_time')),
                  _buildTableCell(translate('table.workers')),
                  _buildTableCell(translate('timesheet.status')),
                ],
              );
            }

            return TableRow(
              children: [
                _buildTableCell(shift.jobsite!),
                _buildTableCell(DateFormat.jm().format(shift.datetime!)),
                _buildTableCell(shift.workers.toString()),
                _buildTableCell(
                  shift.isFulfilled!
                      ? translate('group.title.fulfilled')
                      : translate('group.title.unfulfilled'),
                  shift.isFulfilled! ? (Colors.green[400])! : (Colors.red[400])!,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildClientCalendar(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          TableCalendar(
            daysOfWeekHeight: SizeConfig.heightMultiplier * 4.39,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.04,
              ),
              weekendStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.04,
                color: Colors.red[400],
              ),
            ),
            availableGestures: AvailableGestures.none,
            headerStyle: HeaderStyle(
              leftChevronMargin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 4.87,
              ),
              rightChevronMargin: EdgeInsets.only(
                right: SizeConfig.widthMultiplier * 4.87,
              ),
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              leftChevronIcon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: SizeConfig.heightMultiplier * 2.56,
              ),
              rightChevronIcon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: SizeConfig.heightMultiplier * 2.56,
              ),
            ),

            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              disabledTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              outsideTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              selectedTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
              weekendTextStyle: TextStyle(
                fontSize: SizeConfig.heightMultiplier * 2.34,
                color: Colors.red[500],
              ),
            ),
            //todo: revert to one month later for ruslanzaharov1105@gmail.com, later remove it
            focusedDay: _currentDay!,
            firstDay: DateTime.now().subtract(
              Duration(
                days: 365,
              ),
            ),
            lastDay: Jiffy.now().add(years: 1).dateTime,
            currentDay: _currentDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (date, events) {
              List<Shift> shifts = [];
              if (_clientFulfilledShifts != null) {
                _clientFulfilledShifts?.values
                    .forEach((shift) => shifts.forEach((element) {
                          shifts.add(element);
                        }));
              }
              if (_clientUnfulfilledShifts != null) {
                _clientUnfulfilledShifts?.values
                    .forEach((shift) => shifts.forEach((element) {
                          shifts.add(element);
                        }));
              }
              if (_clientPendingShifts != null) {
                _clientPendingShifts?.values
                    .forEach((shift) => shifts.forEach((element) {
                          shifts.add(element);
                        }));
              }

              setState(() {
                _shifts = shifts;
                _currentDay = date;
              });

            },
            calendarBuilders: CalendarBuilders(
              outsideBuilder:
                  (BuildContext context, DateTime day, DateTime focusedDay) =>
                      SizedBox(),
              disabledBuilder:
                  (BuildContext context, DateTime day, DateTime focusedDay) =>
                      day.month == DateTime.now().month ? null : SizedBox(),
              markerBuilder: (context, date, events) {

                if (_clientFulfilledShifts != null && _clientUnfulfilledShifts != null) {
                  if ( _clientFulfilledShifts?[date] != null && _clientUnfulfilledShifts?[date] != null) {
                    return Positioned(
                      bottom: SizeConfig.heightMultiplier * 0.29,
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Ensures the Row only takes as much space as needed
                        children: [
                          _buildRectangle(
                            width: SizeConfig.widthMultiplier * 1.5, // Define the width as needed
                            height: SizeConfig.heightMultiplier * 1, // Define the height as needed
                            color: Colors.green[400]!,
                          ),
                          SizedBox(width: SizeConfig.widthMultiplier * 0.97), // Spacing between circles
                          _buildRectangle(
                            width: SizeConfig.widthMultiplier * 1.5, // Define the width as needed
                            height: SizeConfig.heightMultiplier * 1, // Define the height as needed
                            color: Colors.red[400]!,
                          ),
                        ],
                      ),
                    );
                  }
                }

                if (_clientFulfilledShifts != null) {
                  if (_clientFulfilledShifts?[date] != null) {
                    return Positioned(
                      //bottom: 2,
                      bottom: SizeConfig.heightMultiplier * 0.29,
                      child: _buildRectangle(
                        width: SizeConfig.widthMultiplier * 1.5, // Define the width as needed
                        height: SizeConfig.heightMultiplier * 1, // Define the height as needed
                        color: Colors.green[400]!,
                      ),
                    );
                  }
                }

                if (_clientUnfulfilledShifts != null) {
                  if (_clientUnfulfilledShifts?[date] != null) {
                    return Positioned(
                      //bottom: 2,
                      bottom: SizeConfig.heightMultiplier * 0.29,
                      child: _buildRectangle(
                        width: SizeConfig.widthMultiplier * 1.5, // Define the width as needed
                        height: SizeConfig.heightMultiplier * 1, // Define the height as needed
                        color: Colors.red[400]!,
                      ),
                    );
                  }
                }

                if (_clientPendingShifts != null) {
                  if (_clientPendingShifts?[date] != null) {
                    return Positioned(
                      //bottom: 2,
                      bottom: SizeConfig.heightMultiplier * 0.29,
                      child: _buildRectangle(
                        width: SizeConfig.widthMultiplier * 1.5, // Define the width as needed
                        height: SizeConfig.heightMultiplier * 1, // Define the height as needed
                        color: (Color(0xFFF58926)),
                      ),
                    );
                  }
                }

                return SizedBox();
              },
            ),
          ),
          _buildTable(_shifts!),
          // _buildClientLegend(),
          // _buildTimesheetCounterClient()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints = BoxConstraints(
      maxHeight: size.height,
      maxWidth: size.width,
    );
    SizeConfig().init(constraints, orientation);
    if (widget.type == CalendarType.Canddate) {
      return _buildCandidateCalendar(context);
    }

    if (widget.type == CalendarType.Client) {
      return _buildClientCalendar(context);
    }

    return Container(width: 0.0, height: 0.0);
  }

  //   Widget _buildTimesheetCounterClient() {

  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: SizeConfig.widthMultiplier * 4.87,
  //       vertical: SizeConfig.heightMultiplier * 2.93,
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: _timesheetCounter.timesheetCounter_client
  //           .map(
  //             (el) => Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   children: [
  //                     _buildCircle(
  //                       //radius: 8.0,
  //                       radius: SizeConfig.heightMultiplier * 1.17,
  //                       color: el.color,
  //                     ),
  //                     SizedBox(
  //                       //width: 8.0,
  //                       width: SizeConfig.widthMultiplier * 1.95,
  //                     ),
  //                     Text(
  //                       translate(el.count.toString()),
  //                       style: TextStyle(
  //                         //fontSize: 16.0,
  //                         fontSize: SizeConfig.heightMultiplier * 2.34,
  //                       ),
  //                     ),
  //                   ],
  //                 ),                  
  //                 Text(
  //                   translate(el.text),
  //                   style: TextStyle(
  //                     //fontSize: 16.0,
  //                     fontSize: SizeConfig.heightMultiplier * 2.34,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           )
  //           .toList(),
  //     ),
  //   );
  // }


  _calculateEarning(int index) async {
    DateTime now = DateTime.now();
    //todo: revert to one month later for ruslanzaharov1105@gmail.com
    now = DateTime(now.year, now.month - 1, now.day);
    int lastDay = DateTime(now.year, now.month + 1, 0).day;
    DateTime firstDate = DateTime(now.year, now.month - 1, 1);
    DateTime lastDate = DateTime(now.year, now.month - 1, lastDay);
    if (index == 0) {
      lastDay = DateTime(now.year, now.month + 1, 0).day;
      firstDate = DateTime(now.year, now.month, 1);
      lastDate = DateTime(now.year, now.month, lastDay);      
    } else if (index == 1) {
      lastDay = DateTime(now.year, now.month, 0).day;
      firstDate = DateTime(now.year, now.month + 1, 1);
      lastDate = DateTime(now.year, now.month + 1, lastDay);
    } else if (index == 2) {
      firstDate = findFirstDateOfTheWeek(now);
      lastDate = findLastDateOfTheWeek(now);
    } else if (index == 3) {
      firstDate = now;
      lastDate = now;
    } else if (index == 4) {
      firstDate = DateTime(now.year, 1, 1);
      lastDate = DateTime(now.year, 12, 31);
    } else {
      firstDate = fromDate;
      lastDate = toDate;
    }

    try {
      var data = await _candidateService.getStatistics(
          contactId: widget.candidateId!,
          startedAt0: firstDate,
          startedAt1: lastDate);          
      if (data != null) {
        _candidateWorkStates =
            CandidateWorkState.fromJson(json.decode(data.body));
      }
    } catch (e) {
      print(e);
    }
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  _buildCustomDate() {
    return Visibility(
      visible: _isCustomCounter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              //horizontal: 15.0,
              horizontal: SizeConfig.heightMultiplier * 3.65,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.6,
                  //height: 60,
                  height: SizeConfig.heightMultiplier * 8.78,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(
                          //fontSize: 12,
                          fontSize: SizeConfig.heightMultiplier * 1.75,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        //height: 3,
                        height: SizeConfig.heightMultiplier * 0.43,
                      ),
                      DatePickerBoxWidget(
                        // horPad: 6,
                        // verPad: 9,
                        //fontSize: 12,
                        // imageHeight: 13,
                        // imageWidth: 13,
                        fontSize: SizeConfig.heightMultiplier * 1.3,
                        imageHeight: SizeConfig.heightMultiplier * 1.75,
                        imageWidth: SizeConfig.widthMultiplier * 2.91,
                        horPad: SizeConfig.widthMultiplier * 1.35,
                        verPad: SizeConfig.heightMultiplier * 1.32,
                        initialDate: fromDate,
                        onDateSelected: (DateTime startDate) {
                          DateTime _dateTime = DateTime(
                            startDate.year,
                            startDate.month,
                            startDate.day,
                            fromDate?.hour ?? 0,
                            fromDate?.minute ?? 0,
                          );
                          fromDate = _dateTime;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  //width: 15,
                  width: SizeConfig.widthMultiplier * 3.65,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.6,
                  //height: 60,
                  height: SizeConfig.heightMultiplier * 8.78,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: TextStyle(
                          //fontSize: 12,
                          fontSize: SizeConfig.heightMultiplier * 1.75,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        //height: 3,
                        height:SizeConfig.heightMultiplier*0.44,
                      ),
                      DatePickerBoxWidget(
                        // horPad: 6,
                        // verPad: 9,
                        //fontSize: 12,
                        // imageHeight: 13,
                        // imageWidth: 13,
                        fontSize: SizeConfig.heightMultiplier * 1.3,
                        imageHeight: SizeConfig.heightMultiplier * 1.75,
                        imageWidth: SizeConfig.widthMultiplier * 2.91,
                        horPad: SizeConfig.widthMultiplier * 1.35,
                        verPad: SizeConfig.heightMultiplier * 1.32,
                        initialDate: toDate,
                        onDateSelected: (DateTime startDate) {
                          DateTime _dateTime = DateTime(
                            startDate.year,
                            startDate.month,
                            startDate.day,
                            toDate?.hour ?? 0,
                            toDate?.minute ?? 0,
                          );
                          toDate = _dateTime;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  //width: 20,
                  width: SizeConfig.widthMultiplier * 4.87,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      //top: 15.0,
                      top: SizeConfig.heightMultiplier * 2.34,
                    ),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                          _isCustomCounter = false;
                        });
                        await _calculateEarning(5);
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Container(
                        //height: 44,
                        height: SizeConfig.heightMultiplier * 6.44,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.all(
                            //Radius.circular(7),
                            Radius.circular(
                              SizeConfig.heightMultiplier * 1.02,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              //fontSize: 13,
                              fontSize: SizeConfig.heightMultiplier * 1.90,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CounterButton extends StatefulWidget {
  const CounterButton(
      {Key? key,
        this.title,
        this.onPressed,
        this.onTapped,
        this.index,
        this.last})
      : super(key: key);
  final String? title;
  final Function()? onPressed;
  final bool? onTapped;
  final int? index;
  final int? last;
  @override
  State<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  double radius = 3;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        widget.onPressed!();
        setState(() {});
      },
      child: Container(
        width: /*((size.width * (widget.title.length / 25)))*/size.width > 650
            ? size.width < 1355
            ? size.width / 6.6
            : size.width / 9.2
            : size.width / 3.6,
        padding: EdgeInsets.symmetric(
          // horizontal: 15,
          // vertical: 3,
          //horizontal: SizeConfig.widthMultiplier * 3.65,
          vertical: SizeConfig.heightMultiplier * 0.44,
        ),
        decoration: BoxDecoration(
          color: widget.onTapped! ? AppColors.darkBlue : Colors.white,
          // borderRadius: widget.index == widget.last || widget.index == 0
          //     ? BorderRadius.only(
          //         topLeft: widget.index == 0
          //             ? Radius.circular(radius)
          //             : Radius.circular(2),
          //         bottomLeft: widget.index == 0
          //             ? Radius.circular(radius)
          //             : Radius.circular(2),
          //         bottomRight: widget.index == widget.last
          //             ? Radius.circular(radius)
          //             : Radius.circular(2),
          //         topRight: widget.index == widget.last
          //             ? Radius.circular(radius)
          //             : Radius.circular(2),
          //       )
          //     : BorderRadius.circular(1),
          border: Border.all(
            color: widget.onTapped! ? AppColors.blueBorder : Colors.black,
            width: 0.3,
          ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text(
              widget.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                //fontSize: 16,
                // fontSize: SizeConfig.heightMultiplier * 2.34,
                color: widget.onTapped! ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
