import 'dart:convert';
import 'package:piiprent/widgets/toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:piiprent/models/timesheet_model.dart';
import 'package:piiprent/models/tracking_model.dart';
import 'package:piiprent/services/api_service.dart';

class TimesheetService {
  final ApiService apiService = ApiService.create();

  Future getActiveTimeheets() async {
    Map<String, dynamic> params = {
      'fields': Timesheet.requestFields,
      'shift_started_at_0': DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: 1)),
      ),
    };

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return timesheets.map((Timesheet timesheet) {
        return {
          'from': timesheet.shiftStart!
              .subtract(Duration(hours: 1))
              .toUtc()
              .toString(),
          'to':
              timesheet.shiftStart!.add(Duration(hours: 15)).toUtc().toString(),
          'id': timesheet.id,
        };
      }).toList();
    } else {
      throw Exception('Failed to load Active Timesheets');
    }
  }

  Future getCandidateTimesheets([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'fields': Timesheet.requestFields,
      'approved_only': "1",
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return {"list": timesheets, "count": body["count"]};
    } else {
      throw Exception('Failed to load Timesheets');
    }
  }

  Future getUnapprovedTimesheets([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'fields': Timesheet.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res = await apiService.get(
        path: '/hr/timesheets/unapproved/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return {"list": timesheets, "count": body["count"]};
    } else {
      throw Exception('Failed to load unapproved Timesheets');
    }
  }

  Future getHistoryTimesheets([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'fields': Timesheet.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/timesheets/history/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return {"list": timesheets, "count": body["count"]};
    } else {
      throw Exception('Failed to load approved Timesheets');
    }
  }

  Future getCandidatePreShiftTimesheets([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      "status": '1',
      'fields': Timesheet.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return {"list": timesheets, "count": body["count"]};
    } else {
      throw Exception('Failed to load pre shift Timesheets');
    }
  }

  Future<int> getCandidatePreShiftTimesheetsCount() async {
    Map<String, dynamic> params = {
      "status": '1',
      'limit': '-1',
      'fields': ['id'],
    };

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      int count = body['count'];

      return count;
    } else {
      throw Exception('Failed to load pre shift timesheets count');
    }
  }

  Future getCandidateForSubmitTimesheets([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'status': '4',
      'fields': Timesheet.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Timesheet> timesheets =
          results.map((dynamic el) => Timesheet.fromJson(el)).toList();

      return {"list": timesheets, "count": body["count"]};
    } else {
      throw Exception('Failed to load Timesheets');
    }
  }

  Future<int> getCandidateForSubmitTimesheetsCount() async {
    Map<String, dynamic> params = {
      'status': '4',
      'limit': '-1',
      'fields': ['id'],
    };

    http.Response res =
        await apiService.get(path: '/hr/timesheets-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      int count = body['count'];

      return count;
    } else {
      throw Exception('Failed to load submit timesheets count');
    }
  }

  Future getNotificationTimesheets([Map<String, dynamic>? query]) async {
    var preShiftTimesheets =
        await getCandidatePreShiftTimesheets({'limit': '-1'});
    var submitTimesheets =
        await getCandidateForSubmitTimesheets({'limit': '-1'});

    preShiftTimesheets['list'].addAll(submitTimesheets['list']);

    return {
      "list": preShiftTimesheets['list'],
      "count": preShiftTimesheets['list'].length
    };
  }

  Future<bool> acceptPreShiftCheck(String id) async {
    Map<String, dynamic> body = Map();

    http.Response res = await this.apiService.post(
          path: 'hr/timesheets/$id/confirm/',
          body: body,
        );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to accept Pre-shift check');
    }
  }

  Future<bool> declinePreShiftCheck(String id) async {
    Map<String, dynamic> body = Map();

    http.Response res = await this.apiService.post(
          path: 'hr/timesheets/$id/decline/',
          body: body,
        );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to decline Pre-shift check');
    }
  }

  Future<bool> submitTimesheet(String id, body) async {
    http.Response res = await this.apiService.put(
          path: 'hr/timesheets-candidate/$id/submit/',
          body: body,
        );
    if (res.statusCode == 200) {
      return true;
    } else {
      if (res.statusCode == 400) {
        Map<String, dynamic> responseBody =
            json.decode(utf8.decode(res.bodyBytes));
        throw responseBody['errors']['shift_started_at'] != null
            ? responseBody['errors']['shift_started_at'][0]
            : responseBody['errors']['non_field_errors'] != null
                ? responseBody['errors']['non_field_errors'][0]
                : 'Failed to submit Timesheet';
      }
      throw Exception('Failed to submit Timesheet');
    }
  }

  Future<bool> approveTimesheet(
    String id,
    Map<String, dynamic> body,
    bool updated,
  ) {
    if (updated) {
      return _notAgree(id, body);
    } else {
      if (body.containsKey('supervisor_signature')) {
        return _approveBySignature(id, body['supervisor_signature']);
      } else {
        return _approve(id, body);
      }
    }
  }

  Future<bool> evaluate(String id, int score) async {
    http.Response res = await this.apiService.put(
      path: '/hr/timesheets/$id/evaluate/',
      body: {'evaluation_score': score},
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to evaluate Timesheet');
    }
  }

  Future<bool> _approve(String id, Map<String, dynamic> body) async {
    Map<String, dynamic> req_body = {
      ...body,
      'no_break': true,
      'send_candidate_message': false,
      'send_supervisor_message': false
    };
    http.Response res = await this.apiService.put(
          path: '/hr/timesheets/$id/approve/',
          body: body,
        );

    if (res.statusCode == 200) {
      toast('Approved successfully');
      return true;
    } else {
      throw Exception('Failed to approve Timesheet');
    }
  }

  Future<bool> _approveBySignature(String id, String signature) async {
    http.Response res = await this.apiService.post(
      path: '/hr/timesheets/$id/approve_by_signature/',
      body: {'supervisor_signature': signature},
    );

    if (res.statusCode == 200) {
      toast('Approved successfully');
      return true;
    } else {
      throw Exception('Failed to approve by signature Timesheet');
    }
  }

  Future<bool> _notAgree(String id, Map<String, dynamic> body) async {
    Map<String, dynamic> req_body = {
      ...body,
      "hours": true
    };
    http.Response res = await this.apiService.put(
          path: '/hr/timesheets/$id/not_agree/',
          body: req_body,
        );

    if (res.statusCode == 200) {
      toast('Approved successfully');
      return true;
    } else {
      throw Exception('Failed to change timesheet times');
    }
  }

  Future<List<Tracking>?> getTrackingData(
    String candidateId,
    String timesheetId,
  ) async {
    Map<String, dynamic> params = {
      'timesheet': timesheetId,
      'limit': '-1',
    };

    try {
      http.Response res = await this.apiService.get(
            path: '/candidate/location/$candidateId/history/',
            params: params,
          );

      if (res.statusCode == 200) {
        Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
        List<dynamic> results = body['results'];

        return results
            .map((dynamic element) => Tracking.fromJson(element))
            .toList();
      } else {
        throw Exception('Failed to load tracking data');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
