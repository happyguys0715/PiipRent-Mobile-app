import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/models/skill_activity_model.dart';
import 'package:piiprent/screens/timesheets_details/selected_time_details.dart';
import 'package:piiprent/screens/timesheets_details/widgets/timesheet_general_info_widget.dart';
import 'package:piiprent/services/login_service.dart';
import 'package:piiprent/services/note_service.dart';
import 'package:piiprent/services/skill_activity_service.dart';
import 'package:piiprent/services/timesheet_service.dart';
import 'package:piiprent/widgets/candidate_app_bar.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:piiprent/widgets/skill_activity_table.dart';
import 'package:piiprent/widgets/toast.dart';

class CandidateTimesheetNewDetailsScreen extends StatefulWidget {
  final String? position;
  final String? jobsite;
  final String? name;
  final String? address;
  final DateTime? shiftDate;
  final DateTime? shiftStart;
  final DateTime? shiftEnd;
  final DateTime? breakStart;
  final DateTime? breakEnd;
  final String? timezone;
  final int? status;
  final String? id;
  final String? positionId;
  final String? companyId;
  final String? candidateId;
  final String? companyStr;

  CandidateTimesheetNewDetailsScreen({
    this.position = '',
    this.jobsite,
    this.name,
    this.address,
    this.shiftDate,
    this.shiftStart,
    this.shiftEnd,
    this.breakStart,
    this.breakEnd,
    this.timezone,
    this.status,
    this.id,
    this.positionId,
    this.companyId,
    this.candidateId,
    this.companyStr,
  });

  @override
  _CandidateTimesheetNewDetailsScreenState createState() =>
      _CandidateTimesheetNewDetailsScreenState();
}

class _CandidateTimesheetNewDetailsScreenState
    extends State<CandidateTimesheetNewDetailsScreen> {
  bool _updated = false;
  bool _fetching = false;
  bool _activityAdded = false;

  SelectedTimeDetails selectedTimeDetails = SelectedTimeDetails();

  String _shiftStart = TimesheetTimeKey[TimesheetTime.Start]!;
  String _breakStart = TimesheetTimeKey[TimesheetTime.BreakStart]!;
  String _breakEnd = TimesheetTimeKey[TimesheetTime.BreakEnd]!;
  String _shiftEnd = TimesheetTimeKey[TimesheetTime.End]!;

  String? _error;
  Map<String, DateTime?> _times = Map();

  String? _note;
  List<String> _imagePathList = [];

  @override
  void initState() {
    DateTime? _breakTime;
    if (widget.shiftStart != null)
      _breakTime =
          widget.breakStart ?? widget.shiftStart!.add(Duration(hours: 2));

    // DateTime? _shiftEndTime;
    // if (widget.shiftEnd == null) {
    //   _shiftEndTime = widget.shiftStart!.add(Duration(hours: 2));
    // }
    // else {
    //   _shiftEndTime = widget.shiftEnd!;
    // }

    _times = {
      _shiftStart: widget.shiftStart!,
      _breakStart: _breakTime!,
      _breakEnd: widget.breakEnd ?? _breakTime,
      _shiftEnd: widget.shiftEnd
    };
    _getActivity();

    super.initState();
  }

  _getActivity() async {
    List<SkillActivity> data =
        await SkillActivityService().getSkillActivitiesByTimesheet({
      'timesheet': widget.id,
      'skill': widget.positionId,
    });

    if(data.length == 0) {
      _activityAdded = false;
    } else {
      _activityAdded = true;
    }
  }

  _acceptPreShiftCheck(TimesheetService timesheetService) async {
    try {
      setState(() => _fetching = true);
      bool result = await timesheetService.acceptPreShiftCheck(widget.id!);

      setState(() => _updated = result);
    } catch (e) {
      print(e);
    } finally {
      setState(() => _fetching = false);
    }
  }

  _declinePreShiftCheck(TimesheetService timesheetService) async {
    try {
      setState(() => _fetching = true);
      bool result = await timesheetService.declinePreShiftCheck(widget.id!);

      setState(() => _updated = result);
    } catch (e) {
      print(e);
    } finally {
      setState(() => _fetching = false);
    }
  }

  _updateNote(String note) {
    setState(() => _note = note);
  }

  _submitForm(TimesheetService timesheetService, NoteService noteService, String contactId, bool isDelete) async {
    if (_times.values.contains(null)) {
      toast("Select Time");
      return;
    }

    try {
      setState(() => {
        _fetching = true,
        _error = null,
      });
      
      if ((_note != null && _note!.isNotEmpty) || _imagePathList.length > 0) {
        await noteService.createNote(contactId, _note!, widget.id!, _imagePathList);
      }

      changeDateForm(inputDate) {
        String originalDateString = inputDate;
        DateTime originalDate = DateTime.parse(originalDateString);

        // Format the date
        String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:00'Z'").format(originalDate);

        return formattedDate;
      }

      Map<String, String> body;
      body = _times.map((key, value) =>
          MapEntry(key, isDelete ? '' : changeDateForm(value?.toUtc().toString())));
                if (isDelete == false) {
        body['hours'] = 'true';
      }

      if (isDelete == false) {
        toast('Time and activities submitting');
      }

      bool result = await timesheetService.submitTimesheet(widget.id!, body);
      if (result && isDelete) {
        _times.forEach((key, value) {
          if (key != _shiftStart) {
            if (key == _breakStart || key == _breakEnd) {
              _times[key] = _times[_shiftStart]!.add(Duration(hours: 2));
            } else {
              // _times[key] = null;
            }
          }
        });
      }
      setState(() => _updated = result);

      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = e as String?;
      });
    } finally {
      setState(() => _fetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    TimesheetService timesheetService = Provider.of<TimesheetService>(context);
    LoginService loginService = Provider.of<LoginService>(context);
    SkillActivityService skillActivityService = Provider.of<SkillActivityService>(context);
    NoteService noteService = Provider.of<NoteService>(context);

    String contactID = loginService.user!.userId!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: getCandidateAppBar(
            translate('page.title.timesheet'),
            context,
            showNotification: false,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  color:Colors.white,
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    //size: 36.0,
                    size: SizeConfig.heightMultiplier * 5.27,
                  ),
                  onPressed: () {
                    Navigator.pop(context, _updated);
                  },
                );
              },
            ),
            isPadding: true, tabs: []
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('timesheet.subtitle.general'),
                style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 3.22,
                  fontFamily: GoogleFonts
                      .roboto()
                      .fontFamily,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightBlack,
                ),
              ),
              SizedBox(
                //height: 12,
                height: SizeConfig.heightMultiplier * 1.76,
              ),
              GeneralInformationWidget(
                // imageIcon: 'images/icons/ic_profile.svg',
                name: translate('timesheet.supervisor'),
                value: widget.name!, imageIcon: '',
              ),
              GeneralInformationWidget(
                // imageIcon: 'images/icons/ic_building.svg',
                name: translate('timesheet.company'),
                value: widget.companyStr!, imageIcon: '',
              ),
              // GeneralInformationWidget(
              //     // imageIcon: 'images/icons/ic_work.svg',
              //     name: 'JOBSITE',
              //     value: widget.jobsite),
              GeneralInformationWidget(
                // imageIcon: 'images/icons/ic_building.svg',
                name: translate('timesheet.address'),
                value: widget.address!, imageIcon: '',
              ),
              GeneralInformationWidget(
                // imageIcon: 'images/icons/ic_support.svg',
                name: translate('timesheet.position'),
                value: widget.position!, imageIcon: '',
              ),
              GeneralInformationWidget(
                // imageIcon: 'images/icons/ic_calendar.svg',
                name: translate('timesheet.shift_date'),
                value: DateFormat('MMM dd, yyyy').format(widget.shiftDate!), imageIcon: '',
              ),
              SizedBox(
                //height: 12,
                height: SizeConfig.heightMultiplier * 1.75,
              ),

              SizedBox(
                //height: 24,
                height: SizeConfig.heightMultiplier * 3.51,
              ),

              SkillActivityTable(
                hasActions: widget.status == 4 || widget.status == 5,
                service: skillActivityService,
                skill: widget.positionId!,
                timesheet: widget.id!,
                companyId: widget.companyId!,
                candidateId: widget.candidateId!,
                isTimeAdded: _times[_shiftEnd] != null? true : false,
                times: _times,
                timezone: widget.timezone!,
                breakEnd: _breakEnd,
                breakStart: _breakStart,
                shiftEnd: _shiftEnd,
                shiftStart: _shiftStart,
                updateNote: _updateNote,
                imagePathList: _imagePathList,
                status: widget.status!,
                submitted: _activityAdded, onSubmit: null,
              ),

              widget.status == 1 && !_updated
                  ? Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      //bottom: 8.0,
                      bottom: SizeConfig.heightMultiplier * 1.17,
                    ),
                    child: Center(
                      child: Text(
                        translate('message.pre_shift_check'),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FormSubmitButton(
                        label: translate('button.decline'),
                        onPressed: () =>
                            _declinePreShiftCheck(timesheetService),
                        disabled: _fetching,
                        color: (Colors.red[400])!,
                        //horizontalPadding: 50,
                        horizontalPadding:
                        SizeConfig.widthMultiplier * 12.17,
                      ),
                      FormSubmitButton(
                        label: translate('button.accept'),
                        onPressed: () =>
                            _acceptPreShiftCheck(timesheetService),
                        disabled: _fetching,
                        color: (Colors.green[400])!,
                        //horizontalPadding: 50,
                        horizontalPadding:
                        SizeConfig.widthMultiplier * 12.17,
                      ),
                    ],
                  ),
                ],
              )
                  : Container(),
              widget.status == 4 || widget.status == 5/*|| widget.status == 5*/
                  ? SizedBox(
                width: double.infinity,
                child: FormSubmitButton(
                  label: translate('button.submit'),
                  onPressed: () => _submitForm(timesheetService, noteService, contactID, false),
                  disabled: _fetching,
                ),
              )
                  : Container(),
              // widget.status == 5
              //     ? Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     translate('timesheet.status.approval_pending'),
              //     style: TextStyle(
              //       fontSize: SizeConfig.heightMultiplier * 2.34,
              //       fontFamily: GoogleFonts
              //           .roboto()
              //           .fontFamily,
              //       fontWeight: FontWeight.w800,
              //       color: AppColors.blue,
              //     ),
              //   ),
              // )
              //     : Container(),
              _error != null
                  ? Padding(
                padding: EdgeInsets.symmetric(
                  //vertical: 8.0,
                  vertical: SizeConfig.heightMultiplier * 1.17,
                ),
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                  ),
                ),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
