import 'package:get/get.dart';
import 'package:piiprent/helpers/functions.dart';

class Skill {
  final String? id;
  final Map<String, Map<String, String>>? translations;
  final String? skillName;

  static final requestFields = [
    'id',
    'name',
  ];

  Skill({
    this.id,
    this.translations,
    this.skillName,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    Map<String, Map<String, String>> translations = {
      'name': generateTranslations(
        json['name']['translations'],
        json['name']['__str__'],
      )
    };

    return Skill(
      id: json['id'],
      translations: translations,
      skillName: json['name']['id'],
    );
  }

  String? get name {
    String locale = Get.locale!.languageCode;
    String? translatedName = translations?['name']![locale];

    return translatedName ?? translations?['name']?['en'];
  }
}
