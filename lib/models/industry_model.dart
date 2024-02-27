import 'package:get/get.dart';
import 'package:piiprent/helpers/functions.dart';

class Industry {
  final String? id;
  final Map<String, Map<String, String>>? translations;

  static final requestFields = [
    'id',
    'translations',
    '__str__',
  ];

  Industry({
    this.id,
    this.translations,
  });

  factory Industry.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, String>> translations = {
      'name': generateTranslations(
        json['translations'],
        json['__str__'],
      )
    };

    return Industry(
      id: json['id'] as String,
      translations: translations,
    );
  }

  String? get name {
    String locale = Get.locale!.languageCode;
    String? translatedName = translations?['name']?[locale];

    return translatedName ?? translations?['name']?['en'];
  }
}
