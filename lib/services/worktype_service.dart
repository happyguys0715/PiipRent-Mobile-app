import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/worktype_model.dart';
import 'package:piiprent/services/api_service.dart';

class WorktypeService {
  final ApiService apiService = ApiService.create();

  Future getSkillWorktypes([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'fields': Worktype.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/skills/worktypes/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Worktype> worktypes =
          results.map((dynamic el) => Worktype.fromJson(el)).toList();

      return worktypes;
    } else {
      throw Exception('Failed to load Work Types');
    }
  }
}
