import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/models/skill_activity_model.dart';
import 'package:piiprent/models/worktype_model.dart';
import 'package:piiprent/services/skill_activity_service.dart';
import 'package:piiprent/services/worktype_service.dart';
import 'package:piiprent/widgets/form_message.dart';
import 'package:piiprent/widgets/form_submit_button.dart';
import 'package:piiprent/widgets/size_config.dart';
import 'package:provider/provider.dart';

class CandidateSkillActivityScreen extends StatefulWidget {
  final String? timesheet;
  final List<SkillActivity> addedskill;
  final String? skill;
  final String? companyId;
  final String? candidateId;
  final SkillActivity? skillActivityModel;

  CandidateSkillActivityScreen(
      {this.timesheet, required this.addedskill, this.skill, this.companyId, this.candidateId, this.skillActivityModel});

  @override
  _CandidateSkillActivityScreenState createState() =>
      _CandidateSkillActivityScreenState();
}

class _CandidateSkillActivityScreenState
    extends State<CandidateSkillActivityScreen> {
  String? _worktype;
  String? _rate;
  double? _value;
  String hint = 'Activity';

  bool _fetching = false;
  String? _error;
  List<Worktype> data = [];

  TextEditingController amountTextController = TextEditingController();

  _onSubmit(SkillActivityService service, context) async {
    if (_worktype == null) {
      Get.snackbar('Select Activity', '');
      return;
    }

    if (_value == null) {
      Get.snackbar('Enter Amount', '');
      return;
    }

    setState(() {
      _fetching = true;
      _error = null;
    });

    try {
      await service.createSkillActivity(
        SkillActivityBody(
          rate: double.parse(_rate!),
          worktype: _worktype!,
          value: _value!,
          timesheet: widget.timesheet!,
          skill: widget.skillActivityModel == null ? widget.skill : null,
        ),
        widget.skillActivityModel
      );

      Navigator.pop(context, true);
    } catch (err) {
      setState(() {
        dynamic err;
        String errorMessage = err is Error ? err.toString() : err?.message ?? "Unknown error";
        _error = errorMessage;
      });
    } finally {
      setState(() {
        _fetching = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    callActivityList();
    super.didChangeDependencies();
  }

  void setData(List<Worktype> data) {
    if (widget.skillActivityModel != null) {
      var el = data.firstWhere((element) => element.id == widget.skillActivityModel?.worktype?.id);
      _rate = el.defaultRate;
      
      _worktype = data.firstWhere((element) => element.id == widget.skillActivityModel?.worktype?.id).id;
      hint = data
        .firstWhere((element) => element.id == widget.skillActivityModel?.worktype?.id)
        .name(LocalizedApp.of(context).delegate.currentLocale);
      
      if (widget.skillActivityModel?.value != null) {
        amountTextController.text = widget.skillActivityModel!.value.toString();
      }

      setState(() {});
    }
  }

  callActivityList() async {
    _fetching = true;
    setState(() {});
    var temp = await Provider.of<WorktypeService>(context).getSkillWorktypes(
      {
        'skill': widget.skill,
        'company': widget.companyId,
        'candidate_contact': widget.candidateId,
        'priced': 'true'
      }
    );
    if (temp != null) {
      data.clear();
      var temp2 = temp as List<Worktype>;
      data.addAll(temp2);
      for (SkillActivity activity in widget.addedskill) {
        data.removeWhere((element) => element.id == activity.worktype?.id);
      }
    }

    _fetching = false;
    setState(() {});
        setData(data);
  }

  @override
  Widget build(BuildContext context) {
    SkillActivityService skillActivityService = Provider.of<SkillActivityService>(context);
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color:Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: SizeConfig.heightMultiplier * 5.27,
              ),
              onPressed: () {
                Get.back();
              },
            );
          },
        ),
        title: Text(
          translate('page.title.create_skill_activity'),
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.heightMultiplier * 2.34,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
              size: SizeConfig.heightMultiplier * 3.80,
            ),
            onPressed: () {
              _onSubmit(skillActivityService, context);
            },
          ),
        ]
      ),

      body: _fetching ?
        Center(child: CircularProgressIndicator())
        :
        Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: SizeConfig.heightMultiplier * 2.34,
                horizontal: SizeConfig.widthMultiplier * 3.89,
              ),
              height: SizeConfig.heightMultiplier * 9.81,
              decoration: BoxDecoration(
                color: Color(0xffEEF6FF),
                border: Border.all(
                  width: 1,
                  color: Color(0xffD3DEEA),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    SizeConfig.heightMultiplier * 0.73,
                  ),
                ),
              ),
              padding: EdgeInsets.all(
                SizeConfig.heightMultiplier * 2.93,
              ),
              width: double.infinity,
              child: DropdownButton(
                isExpanded: true,
                underline: SizedBox(),
                hint: Text(
                  hint,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.heightMultiplier * 2.34,
                  ),
                ),
                items: data.map((e) {
                  return DropdownMenuItem(
                      child: Text(
                        e.name(
                          localizationDelegate.currentLocale,
                        ),
                        style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 2.34,
                        ),
                      ),
                      value: e.id
                    );
                }).toList(),
                onChanged: (value) {
                  _worktype = value as String;
                  var el = data.firstWhere((element) => element.id == value);
                  _rate = el.defaultRate;
                  hint = data
                    .firstWhere((element) => element.id == value)
                    .name(localizationDelegate.currentLocale);
                  setState(() {});
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 3.89,
                vertical: SizeConfig.heightMultiplier * 1.46,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 2.43,
              ),
              width: double.infinity,
              height: SizeConfig.heightMultiplier * 8.78,
              decoration: BoxDecoration(
                color: Color(0xffEEF6FF),
                border: Border.all(
                  width: 1,
                  color: Color(0xffD3DEEA),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.heightMultiplier*0.73),
                ),
              ),
              child: TextFormField(
                onChanged: (String value) {
                  _value = double.parse(value);             
                },
                controller: amountTextController,
                decoration: InputDecoration(
                  hintText: translate('field.skill_activity_amount'),
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.heightMultiplier * 2.64,
                ),
              ),
            ),
            FormMessage(
              type: MessageType.Error,
              message: _error,
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 2.34,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 3.89,
              ),
              width: double.infinity,
              child: FormSubmitButton(
                label: translate('button.submit'),
                onPressed: () {
                  _onSubmit(skillActivityService, context);
                },
                disabled: _fetching,
              ),
            )
          ],
        ));
  }
}
