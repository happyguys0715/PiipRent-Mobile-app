import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:piiprent/models/skill_activity_model.dart';
import 'package:piiprent/screens/candidate_skill_activity_screen.dart';
import 'package:piiprent/services/skill_activity_service.dart';
import 'package:piiprent/widgets/group_title.dart';
import 'package:piiprent/widgets/size_config.dart';

class SkillActivityTableOld extends StatefulWidget {
  final bool hasActions;
  final String? timesheet;
  final String? skill;
  final SkillActivityService? service;
  final String? companyId;

  SkillActivityTableOld({
    required this.hasActions,
    this.timesheet,
    this.skill,
    this.service,
    this.companyId,
  });

  @override
  _SkillActivityTableOldState createState() => _SkillActivityTableOldState();
}

class _SkillActivityTableOldState extends State<SkillActivityTableOld> {
  final StreamController<List<SkillActivity>> _streamController =
      StreamController();

  bool _fetching = true;
  bool? _error;

  @override
  void initState() {
    super.initState();

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

      print(data.length);

      setState(() {
        _fetching = false;
        _error = null;
      });

      _streamController.add(data);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = true;
          _fetching = false;
        });
      }
    }
  }

  void deleteSkillActivity(String id) async {
    setState(() {
      _fetching = true;
    });

    try {
      await widget.service!.removeSkillActivity(id);

      getSkillActivities();
    } catch (e) {
      setState(() {
        _fetching = false;
        _error = true;
      });
    }
  }

  Widget _buildTableCell(String text,
      [Color color = Colors.black, Widget? child]) {
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier * 1.17,
        horizontal: SizeConfig.widthMultiplier * 0.97,
      ),
      child: child != null
          ? child
          : Text(
              text,
              style: TextStyle(
                color: color,
                //fontSize: 16.0,
                fontSize: SizeConfig.heightMultiplier * 2.34,
              ),
            ),
    );
  }

  Widget _buildTable(List<SkillActivity> data, BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Column(
      children: [
        Table(
          columnWidths: <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: FixedColumnWidth(
              //48,
              SizeConfig.widthMultiplier * 11.68,
            ),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Colors.grey,
            ),
          ),
          children: data.length > 0
              ? data.asMap().entries.map((e) {
                  int i = e.key;
                  SkillActivity skillActivity = e.value;

                  if (i == 0) {
                    return TableRow(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      children: [
                        _buildTableCell(translate('field.skill_activity')),
                        _buildTableCell(
                          translate('field.skill_activity_amount'),
                        ),
                        widget.hasActions! && !_fetching
                            ? _buildTableCell('')
                            : SizedBox(),
                      ],
                    );
                  }

                  return TableRow(
                    children: [
                      _buildTableCell(skillActivity.worktype!
                          .name(localizationDelegate.currentLocale)),
                      _buildTableCell(skillActivity.value.toString()),
                      Container(
                        //width: 28.0,
                        width: SizeConfig.widthMultiplier * 6.81,
                        child: widget.hasActions!
                            ? _buildTableCell(
                                '',
                                Colors.black,
                                IconButton(
                                  padding: const EdgeInsets.all(0.0),
                                  icon: Icon(
                                    Icons.delete,
                                    size: SizeConfig.heightMultiplier * 3.66,
                                  ),
                                  color:
                                      _fetching ? Colors.grey[400] : Colors.red,
                                  onPressed: () {
                                    if (!_fetching) {
                                      _showDeleteConfirmationDialog(skillActivity.id!);
                                    }
                                  },
                                ),
                              )
                            : SizedBox(),
                      )
                    ],
                  );
                }).toList()
              : [
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                          //8.0,
                          SizeConfig.heightMultiplier * 1.17,
                        ),
                        child: Center(
                          child: Text(
                            translate('message.no_data'),
                            style: TextStyle(
                              fontSize: SizeConfig.heightMultiplier * 2.34,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    BoxConstraints constraints =
        BoxConstraints(maxWidth: size.width, maxHeight: size.height);
    SizeConfig().init(constraints, orientation);

    return Column(children: [
      GroupTitle(title: translate('group.title.skill_activities')),
      StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<SkillActivity> data = snapshot.data;

            return Container(
              child: Column(
                children: [
                  this._buildTable(data, context),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2.34,
                    //height: 16,
                  ),
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
                              fontSize: SizeConfig.heightMultiplier * 2.34,
                            ),
                          ),
                        )
                      : SizedBox(),
                  widget.hasActions && !_fetching
                      ? ElevatedButton(
                          onPressed: () {
                            ///add approve button
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CandidateSkillActivityScreen(
                                      addedskill: [],
                                      timesheet: widget.timesheet,
                                      skill: widget.skill,
                                      companyId: widget.companyId, candidateId: '', skillActivityModel: null,
                                    ),
                              ),
                            )
                                .then((dynamic result) {
                              if (result == true) {
                                getSkillActivities();
                              }
                            });
                          },                          
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            translate('button.add_skill_activity'),
                            style: TextStyle(
                              fontSize: SizeConfig.heightMultiplier * 2.34,
                            ),                        
                          ),
                        )
                      : SizedBox(),
                  _fetching
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(),
                ],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    ]);
  }

  Future<void> _showDeleteConfirmationDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion', style: TextStyle(fontSize: 20.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                deleteSkillActivity(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
