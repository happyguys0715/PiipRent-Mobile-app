import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:piiprent/helpers/colors.dart';
import 'package:piiprent/models/skill_activity_model.dart';
import 'package:piiprent/screens/candidate_skill_activity_screen.dart';
import 'package:piiprent/screens/timesheets_details/time_widget_page.dart';
import 'package:piiprent/screens/timesheets_details/widgets/duation_show_widget.dart';
import 'package:piiprent/screens/timesheets_details/widgets/time_add_widget.dart';
import 'package:piiprent/services/skill_activity_service.dart';
import 'package:piiprent/widgets/size_config.dart';

class SkillActivityTable extends StatefulWidget {
  final bool? hasActions;
  final String? timesheet;
  final String? skill;
  final SkillActivityService? service;
  final String? companyId;
  final String? candidateId;
  final bool? isTimeAdded;
  final Map<String, DateTime?> times;
  final String timezone;
  final String? shiftEnd;

  final int? status;
  final String? shiftStart;
  final String? breakEnd;
  final String? breakStart;
  final updateNote;
  final List<String>? imagePathList;
  final Function? onSubmit;
  final bool? submitted;


  SkillActivityTable({
    this.hasActions,
    this.timesheet,
    this.skill,
    this.service,
    this.companyId,
    this.candidateId,
    this.isTimeAdded,
    this.status,
    required this.times,
    required this.timezone,
    this.shiftEnd,
    this.shiftStart,
    this.breakEnd,
    this.breakStart,
    this.updateNote,
    this.imagePathList,
    this.onSubmit,
    this.submitted,
  });

  @override
  _SkillActivityTableState createState() => _SkillActivityTableState();
}

class _SkillActivityTableState extends State<SkillActivityTable> {
  final StreamController<List<SkillActivity>> _streamController =
      StreamController();

  bool _fetching = true;
  bool? _error;
  Map<String, DateTime?>? _initialTimes;

  @override
  void initState() {
    super.initState();

    _initialTimes = {...widget.times};
    getSkillActivities();
  }

  void getSkillActivities() async {
    setState(() {
      _fetching = true;
    });

    try {
      List<SkillActivity> data =
        await widget.service!.getSkillActivitiesByTimesheet({
          'timesheet': widget.timesheet,
          'skill': widget.skill,
        });

      setState(() {
        _fetching = false;
        _error = null;
      });

      _streamController.add(data);
    } catch (e) {
      setState(() {
        _error = true;
        _fetching = false;
      });
    }
  }

  void deleteSkillActivity(String id) async {
    setState(() {
      _fetching = true;
    });

    try {
      await widget.service?.removeSkillActivity(id);

      getSkillActivities();
    } catch (e) {
      setState(() {
        _fetching = false;
        _error = true;
      });
    }
  }

  _onTapImage(
    BuildContext context,
  ) async {
    final ImagePicker _picker = ImagePicker();
    List<XFile> images = await _picker.pickMultiImage();

    if (images != null)
    {
      for (XFile file in images)
      {
        widget.imagePathList?.add(file.path);
      }
      setState(() {});
    }
    else
    {
      Get.snackbar('Fail', 'No Image selected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    }
  }

  _removeFile(int idx) {
    widget.imagePathList?.removeAt(idx);
    setState(() { });
  }

  _uploadImages(BuildContext context) {
    if (widget.imagePathList?.length == 0) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.widthMultiplier * 2.43,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.imagePathList?.length,
      padding: EdgeInsets.only(
        bottom: SizeConfig.widthMultiplier * 2.43,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: ((context, index) {
        return InkWell(
          onTap: () { _removeFile(index); },
          child: Image.file(
            File(widget.imagePathList![index]),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )
        );
      })
    );
  }

  /*submitForm(TimesheetService timesheetService, bool isDelete) async {
    if (widget.times.values.contains(null)) {
      //Get.snackbar("Select Time", '');
      toast("Select Time");
      return;
    }

    try {
      setState(() => _fetching = true);
      setState(() {
        _error = null;
      });
      Map<String, String> body;
      body = widget.times.map((key, value) =>
          MapEntry(key, isDelete ? null : value.toUtc().toString()));
      if (isDelete == false) {
        body['hours'] = 'true';
      }

      if (isDelete == false) {
        toast('Time and activities submitting');
      }

      bool result = await timesheetService.submitTimesheet(widget.id, body);
      if (result && isDelete) {
        widget.times.forEach((key, value) {
          if (key != widget.shiftStart) {
            if (key == widget.breakStart || key == widget.breakEnd) {
              widget.times[key] = widget.times[widget.shiftStart].add(Duration(hours: 2));
            } else {
              widget.times[key] = null;
            }
          }
        });
      }
      setState(() => _updated = result);
      Get.back();
    } catch (e) {
      print(e);
      // Get.snackbar(e.toString(), '');
      setState(() {
        _error = e;
      });
    } finally {
      setState(() => _fetching = false);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<SkillActivity> data = snapshot.data;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate('timesheet.subtitle.time'),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.heightMultiplier * 3.22,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      color: AppColors.lightBlack,
                    ),
                  ),
                  if (widget.status == 4 || widget.status == 5)
                    // widget.times?[widget.shiftEnd] != null ?
                      Row(
                        mainAxisSize: MainAxisSize.min, 
                        children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.heightMultiplier * 0.44),
                            child: InkWell(
                              onTap: () async {
                                var result = await Get.to(() => TimeSheetWidgetPage(widget.times, widget.timezone,));
                                if (result is Map) {
                                  setState(() {
                                    result.forEach((key, value) => widget.times[key] = value);
                                  });
                                }
                              },
                              child: Icon(
                                Icons.edit,
                                color: AppColors.green,
                                size: SizeConfig.heightMultiplier * 2.64,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 3.89,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.heightMultiplier * 0.44,
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _initialTimes!.forEach((key, value) => widget.times[key] = value);
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: AppColors.red,
                                size: SizeConfig.heightMultiplier * 2.64,
                              ),
                            ),
                          )
                        ]
                      )
                    // : 
                      // InkWell(
                      //   onTap: () async {
                      //     var result = await Get.to(() => TimeSheetWidgetPage(widget.times!, widget.timezone!,));
                      //     if (result is Map) {
                      //       setState(() {
                      //         result.forEach((key, value) => widget.times?[key] = value);
                      //       });
                      //     }
                      //   },
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: SizeConfig.widthMultiplier * 1.95,
                      //       vertical: SizeConfig.heightMultiplier * 0.44,
                      //     ),
                      //     child: Text(
                      //       translate('button.add'),
                      //       style: TextStyle(
                      //         color: AppColors.blue,
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: SizeConfig.heightMultiplier * 2.05,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                ],
              ),

              // if (widget.times?[widget.shiftEnd] != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1.5,
                    ),
                    TimeAddWidget(
                      translate('timesheet.start_time'),
                      widget.times[widget.shiftStart],
                    ),
                    if (widget.times[widget.shiftEnd] != null)
                      TimeAddWidget(
                        translate('timesheet.end_time'),
                        widget.times[widget.shiftEnd],
                      ),
                    if (widget.times[widget.shiftEnd] == null)
                      TimeAddWidget(
                        translate('timesheet.end_time'),
                        '',
                      ),
                    DurationShowWidget(
                      translate('timesheet.break_time'),
                      widget.times[widget.breakEnd]!.difference(widget.times[widget.breakStart]!),
                    )
                  ],
                ),
              
              SizedBox(
                height: SizeConfig.heightMultiplier * 3.51,
              ),

              _fetching
                  ? Container(
                      margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.heightMultiplier * 2.93,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.hasActions!
                            // ? (/*data.length == 0*/!widget.submitted! && !widget.isTimeAdded!)
                            // ? (/*data.length == 0*/!widget.submitted!)
                            // (/*data.length == 0*/!widget.submitted!)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        translate('timesheet.subtitle.activity'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          //fontSize: 16,
                                          fontSize: SizeConfig.heightMultiplier * 3.22,
                                          fontFamily: GoogleFonts.roboto().fontFamily,
                                          color: AppColors.lightBlack,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CandidateSkillActivityScreen(
                                                    addedskill: data,
                                                    skill: widget.skill,
                                                    timesheet: widget.timesheet,
                                                    companyId: widget.companyId,
                                                    candidateId: widget.candidateId, skillActivityModel: null,
                                                  ),
                                            ),
                                          ).then((dynamic result) {
                                            if (result == true) {
                                              getSkillActivities();
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.widthMultiplier * 1.95,
                                            vertical: SizeConfig.heightMultiplier * 0.44,
                                          ),
                                          child: Text(
                                            translate('button.add'),
                                            style: TextStyle(
                                              color: AppColors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeConfig.heightMultiplier * 2.05,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                // : SizedBox(),
                            : SizedBox(),
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        ),
                        widget.hasActions!
                            ? SizedBox()
                            : Text(
                                translate('timesheet.subtitle.activity'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.heightMultiplier * 3.22,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  color: AppColors.lightBlack,
                                ),
                              ),
                        SizedBox(height: 10),
                        ListView.builder(
                          itemBuilder: (context, index) => Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data[index].worktype != null
                                      ? data[index].worktype?.name == null
                                          ? ""
                                          : data[index].worktype!.name(
                                              localizationDelegate
                                                  .currentLocale)
                                      : "",
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.roboto().fontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: SizeConfig.heightMultiplier * 1.76,
                                    color: AppColors.black,
                                  ),
                                ),
                                widget.hasActions!
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(
                                              SizeConfig.heightMultiplier * 0.44,
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                      CandidateSkillActivityScreen(
                                                        addedskill: [],
                                                        timesheet: widget.timesheet,
                                                        skill: widget.skill,
                                                        companyId: widget.companyId,
                                                        skillActivityModel: data[index], candidateId: '',
                                                      ),
                                                  ),
                                                ).then((dynamic result) {
                                                  if (result == true) {
                                                    getSkillActivities();
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: AppColors.green,
                                                size: SizeConfig.heightMultiplier * 2.85,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.widthMultiplier * 3.89,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: SizeConfig.heightMultiplier * 0.44,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                if (!_fetching) {
                                                  deleteSkillActivity(data[index].id!);
                                                }
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: AppColors.red,
                                                size: SizeConfig.heightMultiplier * 2.85,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox()
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier * 1.5,
                            ),
                            TimeAddWidget(
                              translate('timesheet.amount'),
                              data[index].value.toString(),
                              widthFixed: false,
                            )
                          ]),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          itemCount: data.length,
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2.34,
                        ),

                        // Notes section
                        Text(
                          translate('timesheet.subtitle.notes'),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig.heightMultiplier * 3.22,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            color: AppColors.lightBlack,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.heightMultiplier * 1.46,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.widthMultiplier * 2.43,
                          ),
                          width: double.infinity,
                          height: SizeConfig.heightMultiplier * 10.5,
                          decoration: BoxDecoration(
                            color: Color(0xffEEF6FF),
                            border: Border.all(
                              width: 1,
                              color: Color(0xffD3DEEA),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                SizeConfig.heightMultiplier*0.73,
                              ),
                            ),
                          ),
                          child: TextFormField(
                            onChanged: (String value) {
                              widget.updateNote(value);
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: SizeConfig.heightMultiplier * 2.64,
                            ),
                          ),
                        ),
                        // End of notes section

                        // Files section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('timesheet.subtitle.files'),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.heightMultiplier * 3.22,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                color: AppColors.lightBlack,
                              ),
                            ),

                            InkWell(
                              onTap: () async {
                                _onTapImage(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  // horizontal: 8.0,
                                  // vertical: 3,
                                  horizontal:
                                      SizeConfig.widthMultiplier * 1.95,
                                  vertical:
                                      SizeConfig.heightMultiplier * 0.44,
                                ),
                                child: Text(
                                  translate('timesheet.upload'),
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w500,
                                    //fontSize: 14,
                                    fontSize:
                                        SizeConfig.heightMultiplier * 2.05,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          child: _uploadImages(context),
                        ),
                        // End of files section

                        _error != null
                            ? Padding(
                                padding: EdgeInsets.only(
                                  //bottom: 8.0,
                                  bottom: SizeConfig.heightMultiplier * 1.17,
                                ),
                                child: Text(
                                  translate('message.has_error'),
                                  style: TextStyle(
                                    color: Colors.red[400],
                                    fontSize:
                                        SizeConfig.heightMultiplier * 2.34,
                                  ),
                                ),
                              )
                            : SizedBox()
                      ],
                    )
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
