import 'dart:async';

import 'package:piiprent/services/job_offer_service.dart';
import 'package:piiprent/services/timesheet_service.dart';

class NotificationService {
  JobOfferService _jobOfferService = JobOfferService();
  TimesheetService _timesheetService = TimesheetService();

  StreamController _jobOfferStreamController = StreamController.broadcast();
  StreamController _timesheetStreamController = StreamController.broadcast();

  get jobOfferStream {
    return _jobOfferStreamController.stream;
  }

  get timesheetStream {
    return _timesheetStreamController.stream;
  }

  Future<bool> checkJobOfferNotifications() async {
    try {
      int count = await _jobOfferService.getCandidateJobOffersCount();

      _jobOfferStreamController.add(count > 0);
      return count > 0;
    } catch (e) {
      throw Exception('Failed to load Job Offers Notifications');
    }
  }

  Future<bool> checkTimesheetNotifications() async {
    try {
      int preShiftCount =
          await _timesheetService.getCandidatePreShiftTimesheetsCount();
      int forSubmitCount =
          await _timesheetService.getCandidateForSubmitTimesheetsCount();

      _timesheetStreamController.add(preShiftCount > 0 || forSubmitCount > 0);
      return preShiftCount > 0 || forSubmitCount > 0;
    } catch (e) {
      throw Exception('Failed to load Timesheet Notifications');
    }
  }
}
