import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/jobsite_model.dart';
import 'package:piiprent/services/api_service.dart';

class JobsiteService {
  final ApiService apiService = ApiService.create();

  Future getJobsites([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'fields': Jobsite.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/jobsites/client_contact_jobsite/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Jobsite> jobsites =
          results.map((dynamic el) => Jobsite.fromJson(el)).toList();

      return {"list": jobsites, "count": body["count"]};
    } else {
      throw Exception('Failed to load Jobsites');
    }
  }
}
