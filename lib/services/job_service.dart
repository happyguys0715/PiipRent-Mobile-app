import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:piiprent/models/job_model.dart';
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/models/shift_model.dart';
import 'package:piiprent/services/api_service.dart';

class JobService {
  final ApiService apiService = ApiService.create();

  Future getCandidateJobs([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'status': '1',
      'fields': JobOffer.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/joboffers-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<JobOffer> jobs =
          results.map((dynamic el) => JobOffer.fromJson(el)).toList();

      return {"list": jobs, "count": body['count']};
    } else {
      throw Exception('Failed to load Job Offers');
    }
  }

  Future getClientJobs([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'fields': Job.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res = await apiService.get(
      path: '/hr/jobs/client_contact_job/',
      params: params,
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Job> jobs = results.map((dynamic el) => Job.fromJson(el)).toList();

      return {"list": jobs, "count": body['count']};
    } else {
      throw Exception('Failed to load Jobs');
    }
  }

  Future getShifts([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'fields': Shift.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res = await apiService.get(
      path: '/hr/shifts/',
      params: params,
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Shift> shifts =
          results.map((dynamic el) => Shift.fromJson(el)).toList();

      return {"list": shifts, "count": body['count']};
    } else {
      throw Exception('Failed to load Jobs');
    }
  }

  Future getClientShifts([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'limit': '-1',
      'fields': ['date', 'time', 'is_fulfilled', 'workers_details'],
      // 'date__shift_date_0': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'date__shift_date_0': '2021-01-01',
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res = await apiService.get(
      path: '/hr/shifts/client_contact_shifts/',
      params: params,
    );

    if (res.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<Shift> shifts =
          body.map((dynamic el) => Shift.fromJson(el)).toList();

      return shifts;
    } else {
      throw Exception('Failed to load Jobs');
    }
  }
}
