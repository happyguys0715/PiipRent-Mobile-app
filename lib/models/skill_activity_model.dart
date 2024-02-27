import 'package:piiprent/helpers/functions.dart';
import 'package:piiprent/models/timesheet_skill_activity_model.dart';
import 'package:piiprent/models/worktype_model.dart';

class SkillActivity {
  TimesheetSkillActivity? timesheet;
  Worktype? worktype;
  double? value;
  double? rate;
  String? id;

  SkillActivity({
    this.timesheet,
    this.rate,
    this.value,
    this.worktype,
    this.id,
  });

  factory SkillActivity.fromJson(Map<String, dynamic> payload) {
    return SkillActivity(
      timesheet: TimesheetSkillActivity.fromJson(payload['timesheet']),
      rate: doubleParse(payload['rate']),
      value: doubleParse(payload['value']),
      worktype: Worktype.fromJson(payload['worktype']),
      id: payload['id'],
    );
  }
}
