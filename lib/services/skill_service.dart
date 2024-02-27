import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/skill_model.dart';
import 'package:piiprent/services/api_service.dart';

class SkillService {
  final ApiService apiService = ApiService.create();

  Future getSkill(String id) async {
    Map<String, dynamic> params = {
      'fields': Skill.requestFields,
    };

    http.Response res =
        await apiService.get(path: '/skills/skills/$id', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      Skill skill = Skill.fromJson(body);

      return skill;
    } else {
      throw Exception('Failed to load Skill');
    }
  }
}
