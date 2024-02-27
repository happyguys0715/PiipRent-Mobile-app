import 'package:piiprent/helpers/functions.dart';

enum JobStatus {
  Unfilled,
  Fullfilled,
  Pending,
  Open,
  Filled,
  Approved,
}

class Job {
  final String? id;
  final String? company;
  final String? jobsite;
  final String? status;
  final String? contact;
  final Map<String, dynamic>? translations;
  final int? workers;
  final JobStatus? isFulfilled;
  final JobStatus? isFulFilledToday;
  final String? notes;
  final DateTime? workStartDate;
  final List<dynamic>? tags;
  final String? address;

  static List<String> requestFields = const [
    'id',
    'jobsite',
    'active_states',
    'customer_company',
    'customer_representative',
    'position',
    'workers',
    'is_fulfilled',
    'is_fulfilled_today',
    'notes',
    'work_start_date',
    'default_shift_starting_time',
    'tags',
  ];

  Job({
    this.id,
    this.company,
    this.jobsite,
    this.status,
    this.contact,
    this.translations,
    this.workers,
    this.isFulfilled,
    this.isFulFilledToday,
    this.notes,
    this.workStartDate,
    this.tags,
    this.address
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> translations = {
      'position': generateTranslations(
        json['position']['name']['translations'],
        json['position']['name']['__str__'],
      ),
    };

    separatedString(address) {
      String input = address;

      List<String> letters = [];
      List<String> numbers = [];

      for (var char in input.split('')) {
        if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
          letters.add(char);
        } else if (RegExp(r'\d').hasMatch(char)) {
          numbers.add(char);
        }
      }

      String result = letters.join('') + ' ' + numbers.join('');

      return result;
    }

    getJobsiteName(String company) {
      List<String> parts = company.split(' - ');
      if (parts.length > 1) {
          return parts[1];
        } else {
          return parts[0];
      }
    }
    
    var streetAddress = separatedString(json['jobsite']["address"]["street_address"]);

    return Job(
      id: json['id'],
      company: json['customer_company']['__str__'],
      jobsite: getJobsiteName(json['jobsite']['__str__']),
      status: json['active_states'][0]['__str__'],
      contact: json['customer_representative']['__str__'],
      translations: translations,
      workers: json['workers'],
      isFulfilled: parseStatus(json['is_fulfilled']),
      isFulFilledToday: parseStatus(json['is_fulfilled_today']),
      notes: json['notes'],
      workStartDate: DateTime.parse(
          '${json['work_start_date']}T${json['default_shift_starting_time']}'),
      tags: json['tags'].map((el) => el['name']).toList(),
      address:"$streetAddress ${json['jobsite']["address"]["postal_code"]} ${json['jobsite']["address"]["state"]["__str__"]}"
    );
  }

  get position {
    return translations?['position']['en'];
  }

  static JobStatus parseStatus(int status) {
    switch (status) {
      case 0:
        return JobStatus.Unfilled;
      case 1:
        return JobStatus.Fullfilled;
      case 2:
        return JobStatus.Pending;
      case 3:
        return JobStatus.Open;
      case 4:
        return JobStatus.Filled;
      case 5:
        return JobStatus.Approved;
      default:
        return JobStatus.Unfilled;
    }
  }
}
