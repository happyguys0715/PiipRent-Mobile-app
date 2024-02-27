import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/services/api_service.dart';

class TimesheetCounterCandidate {
  Status type;
  int count;
  String cssClass;
  String text;
  Color color;

  TimesheetCounterCandidate({required this.type, required this.count, required this.cssClass, required this.text, required this.color});
}

class TimesheetCounterRegular {
  Status type;
  int count;
  String cssClass;
  String text;
  Color color;

  TimesheetCounterRegular({required this.type, required this.count, required this.cssClass, required this.text, required this.color});
}

class TimesheetCounterAdmin {
  Status type;
  int count;
  String cssClass;
  String text;
  Color color;

  TimesheetCounterAdmin({required this.type, required this.count, required this.cssClass, required this.text, required this.color});
}

enum Status { Fullfilled, Unfilled, Pending, Open, Filled, Approved }

class TimesheetData {

  final ApiService apiService = ApiService.create();

    List? jobOffers;
    List? jobOffersId;
    List? timesheets;
    List? timesheetsId;

    TimesheetData({this.jobOffers, this.timesheets});

  List<TimesheetCounterCandidate> timesheetCounterCandidate = [
    TimesheetCounterCandidate(type: Status.Open, count: 0, cssClass: 'text-primary', text: 'open', color: Color(0xFFCC0000)),
    TimesheetCounterCandidate(type: Status.Filled, count: 0, cssClass: 'text-warning', text: 'filled', color: Color(0xFFF58926)),
    TimesheetCounterCandidate(type: Status.Approved, count: 0, cssClass: 'text-success', text: 'approved', color: Color(0xFF00CC00)),
  ];

  List<TimesheetCounterRegular> timesheetCounterClient = [
    TimesheetCounterRegular(type: Status.Fullfilled, count: 0, cssClass: 'text-success', text: 'Filled shifts', color: Color(0xFF00CC00)),
    TimesheetCounterRegular(type: Status.Unfilled, count: 0, cssClass: 'text-danger', text: 'Unfilled shifts', color: Color(0xFFCC0000)),
    TimesheetCounterRegular(type: Status.Pending, count: 0, cssClass: 'text-warning', text: 'Pending shifts', color: Color(0xFFF58926)),
  ];

  List<TimesheetCounterAdmin> timesheetCounterAdmin = [
    TimesheetCounterAdmin(type: Status.Fullfilled, count: 0, cssClass: 'text-success', text: 'Filled shifts', color: Color(0xFF00CC00)),
    TimesheetCounterAdmin(type: Status.Unfilled, count: 0, cssClass: 'text-danger', text: 'Unfilled shifts', color: Color(0xFFCC0000)),
    TimesheetCounterAdmin(type: Status.Pending, count: 0, cssClass: 'text-warning', text: 'Pending shifts', color: Color(0xFFF58926)),
  ];

  // Future<http.Response?> getJobOffers({
  //   required String contactId,
  //   required DateTime startedAt0,
  //   required DateTime startedAt1
  // }) async {
  //   int getDaysInMonth(int year, int month) {
  //     DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
  //     DateTime lastDayOfCurrentMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
  //     return lastDayOfCurrentMonth.day;
  //   }

  //   int daysInMonth = getDaysInMonth(startedAt1.year, startedAt1.month);
  //   var limit = -1;
  //   Map<String, dynamic> params = {
  //     "shift__date__shift_date_0":'${startedAt0.year}-${startedAt0.month}-01',
  //     "shift__date__shift_date_1":'${startedAt1.year}-${startedAt1.month}-$daysInMonth',
  //     "limit": '$limit'
  //   };
    
  //   try {
  //     http.Response res = 
  //     await apiService.get(path: '/hr/joboffers-candidate/', params:params);

  //     if (res.statusCode == 200) {
  //       return res;
  //     } else {
  //       print("error");
  //       throw Exception('no data error');
  //     }

  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<http.Response?> getTimeSheet({
    required String contactId,
    required DateTime startedAt0,
    required DateTime startedAt1,
    required String role
  }) async {
    int getDaysInMonth(int year, int month) {
      DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
      DateTime lastDayOfCurrentMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
      return lastDayOfCurrentMonth.day;
    }

    int daysInMonth = getDaysInMonth(startedAt1.year, startedAt1.month);
    var limit = -1;
    Map<String, dynamic> paramsCandidate = {
      "shift_started_at_0":'${startedAt0.year}-${startedAt0.month}-01',
      "shift_started_at_1":'${startedAt1.year}-${startedAt1.month}-$daysInMonth',
      "limit": '$limit'
    };

    // Map<String, dynamic> paramsClient = {
    //   "data__shift_data_0":'${startedAt0.year}-${startedAt0.month}-01',
    //   "data__shift_data_1":'${startedAt1.year}-${startedAt1.month}-$daysInMonth',
    //   "limit": '$limit'
    // };

    // Map<String, dynamic> paramsAdmin = {
    //   "data__shift_data_0":'${startedAt0.year}-${startedAt0.month}-01',
    //   "data__shift_data_1":'${startedAt1.year}-${startedAt1.month}-$daysInMonth',
    //   "limit": '$limit'
    // };
    
    try {
      if (role == "candidate") {
        http.Response res = 
        await apiService.get(path: '/hr/timesheets-candidate/', params:paramsCandidate);

        if (res.statusCode == 200) {
          return res;
        } else {
          print("error");
          throw Exception('no data error');
        }
      } 
      // else if (role == "client") {
      //   http.Response res = 
      //   await apiService.get(path: '/hr/shifts/client_contact_shifts/', params:paramsClient);

      //   if (res.statusCode == 200) {
      //     return res;
      //   } else {
      //     print("error");
      //     throw Exception('no data error');
      //   }
      // } else {
      //   http.Response res = 
      //   await apiService.get(path: '/hr/shifts/client_contact_shifts/', params:paramsAdmin);

      //   if (res.statusCode == 200) {
      //     return res;
      //   } else {
      //     print("error");
      //     throw Exception('no data error');
      //   }
      // }
    } catch (e) {
      return null;
    }
  }

  // List<String>? fromJsonJobOffers(Map<String, dynamic> json) {
  //   List<String> idList = [];
  //   var results = json["results"];
  //   for (var i=0;i<results.length;i++) {
  //     var id = results[i]["shift"]["id"];
  //     idList.add(id.toString());
  //   }
  //   this.jobOffersId = idList;


  //   // if (results != null && results is List<dynamic> && results.isNotEmpty) {
  //   //   var firstResult = results[0];

  //   //   if (firstResult != null && firstResult is Map<String, dynamic>) {
  //   //     var statusData = firstResult["status"];
  //   //     print('statusData========> $statusData');
  //   //     statusList.add(statusData);

  //   //     if (statusData != null) {
  //   //       if (statusData is String) {
  //   //         print("Status is a String: $statusData");
  //   //       } else if (statusData is List<dynamic> && statusData.isNotEmpty) {
  //   //         var status = statusData[0].toString();
  //   //         jobOffersId = status;
  //   //       } else {
  //   //         print("Unexpected type for statusData");
  //   //       }
  //   //     } else {
  //   //       print("Status is null or not present");
  //   //     }
  //   //   } else {
  //   //     print("Invalid structure for the first result");
  //   //   }
  //   // } else {
  //   //   print("Invalid structure for 'results'");
  //   // }
  // }

  List<String>? fromJsonTimeSheet (Map<String, dynamic> json) {
    List<String> statusList = [];
    // List<String> idList = [];
    var results = json["results"];

    // for (var i=0;i<results.length;i++) {
    //   var id = results[i]["shift"]["id"];
    //   idList.add(id.toString());
    // }

    if (results != null && results is List<dynamic> && results.isNotEmpty) {
      for (var i = 0; i < results.length; i++) {
        var firstResult = results[i];

        if (firstResult != null && firstResult is Map<String, dynamic>) {
          var statusData = firstResult["status"];
          statusList.add(statusData.toString());
        } else {
          print("Invalid structure for the first result");
        } 
      }
    } else {
      print("Invalid structure for 'results'");
    }

    for (var i = 0; i < statusList.length; i++) {
      int statusValue = int.tryParse(statusList[i]) ?? 0;

      if (statusValue < 5) {
        timesheetCounterCandidate[0].count += 1;
      } else if (statusValue == 5) {
        timesheetCounterCandidate[1].count += 1;
      } else if (statusValue > 5) {
        timesheetCounterCandidate[2].count += 1;
      }
    }
  }
}
