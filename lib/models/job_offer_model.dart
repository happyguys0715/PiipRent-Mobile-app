import 'package:get/get.dart';
import 'package:piiprent/helpers/functions.dart';

class JobOffer {
  final String? id;
  final String? company;
  final DateTime? datetime;
  final String? longitude;
  final String? latitude;
  final String? location;
  final String? timezone;
  final String? clientContact;
  final tags;
  final Map<String, dynamic>? translations;
  final String? notes;

  static final requestFields = [
    'id',
    'shift',
    'jobsite_address',
    'jobsite',
  ];

  JobOffer({
    this.id,
    this.company,
    this.datetime,
    this.longitude,
    this.latitude,
    this.location,
    this.timezone,
    this.clientContact,
    this.tags,
    this.translations,
    this.notes,
  });

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    var date = json['shift']['date'];
    var job = date['job'];
    var address = json['jobsite_address'];

    Map<String, dynamic> translations = {
      'position': generateTranslations(
        job['position']['name']['translations'],
        job['position']['name']['__str__'],
      ),
    };

    return JobOffer(
      id: json['id'],
      company: job['customer_company']['__str__'],
      datetime: getDateTime(date['shift_date'], json['shift']['time']),
      longitude: address['longitude'],
      latitude: address['latitude'],
      timezone: job['customer_company']['timezone'],
      location: (address['__str__'] as String).replaceAll('\n', ' '),
      clientContact: job['jobsite']['primary_contact']['name'],
      translations: translations,
      notes: job['notes'], tags: null,
    );
  }

  get position {
    String locale = Get.locale!.languageCode;
    String translatedName = translations?['position'][locale];

    return translatedName ?? translations?['position']['en'];
  }
}

DateTime getDateTime(String date, String time) {
  return DateTime.parse('$date $time');
}
