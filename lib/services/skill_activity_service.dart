import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/skill_activity_model.dart';
import 'package:piiprent/services/api_service.dart';

class SkillActivityBody {
  final String? timesheet;
  final String? worktype;
  final String? skill;
  final double? rate;
  final double? value;

  SkillActivityBody({
    this.timesheet,
    this.worktype,
    this.skill,
    this.rate,
    this.value,
  });

  Map<String, dynamic> getRequestBody() {
    return skill == null
        ? {
            'timesheet': timesheet,
            'worktype': {
              'id': worktype,
            },
            'rate': rate,
            'value': value,
          }
        : {
            'timesheet': timesheet,
            'skill': {
              'id': skill,
            },
            'worktype': {
              'id': worktype,
            },
            'rate': rate,
            'value': value,
          };
  }
}

class SkillActivityService {
  final ApiService apiService = ApiService.create();

  Future<List<SkillActivity>> getSkillActivitiesByTimesheet(
      [Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {};

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/timesheetrates/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<SkillActivity> skillActivities =
          results.map((dynamic el) => SkillActivity.fromJson(el)).toList();

      return skillActivities;
    } else {
      throw Exception('Failed to load Skill Activities');
    }
  }

  Future<bool> createSkillActivity(
    SkillActivityBody body, SkillActivity? activity,
  ) async {

    http.Response res = activity != null
        ? await this.apiService.put(
            path: 'hr/timesheetrates/${activity.id}/',
            body: body.getRequestBody(),
          )
        : await this.apiService.post(
            path: 'hr/timesheetrates/',
            body: body.getRequestBody(),
          );

    if (res.statusCode == 201 || res.statusCode == 200) {
      return true;
    } else {
      String? errorMessage;
      if (res.statusCode == 400) {
        Map<String, dynamic> responseBody = jsonDecode(res.body);
        String errKey = responseBody['errors'].keys.first;
        errorMessage = responseBody['errors'][errKey][0];
      }

      throw Exception(errorMessage ??
          'Failed to ${activity != null ? "edit" : "create"} Skill Activity');
    }
  }

  Future<bool> removeSkillActivity(String id) async {
    http.Response res = await this.apiService.delete(
          path: 'hr/timesheetrates/$id/',
        );

    if (res.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete Skill Activity');
    }
  }
}
