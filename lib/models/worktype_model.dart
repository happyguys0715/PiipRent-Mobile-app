import 'package:piiprent/helpers/functions.dart';

class Worktype {
  String? id;
  String? defaultRate;
  final Map<String, dynamic>? translations;

  static final List<String> requestFields = [
    'name',
    'id',
    'uom',
    'skill_rate_ranges',
    'translations'
  ];

  Worktype({this.id, this.defaultRate, this.translations});

  factory Worktype.fromJson(Map<String, dynamic> payload) {
    var skillRateRanges = payload['skill_rate_ranges'];
    Map<String, dynamic> translations = {
      'name': generateTranslations(
        payload['translations'],
        payload['name'],
      ),
    };

    return Worktype(
        id: payload['id'],
        defaultRate: skillRateRanges != null
            ? payload['skill_rate_ranges'][0]['default_rate']
            : '0.0',
        translations: translations);
  }

  String name(locale) {
    if (locale == 'en_US') {
      return translations?['name']['en'];
    }

    String? tranlsation = translations?['name']?[locale.toString()];

    return tranlsation != null ? tranlsation : translations?['name']['en'];
  }
}
