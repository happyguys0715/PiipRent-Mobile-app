import 'package:piiprent/helpers/functions.dart';

class Tag {
  final String? id;
  final Map<String, String>? translations;

  static final requestFields = [
    'id',
    'translations',
    '__str__',
  ];

  Tag({this.id, this.translations});

  factory Tag.fromJson(Map<String, dynamic> json) {
    Map<String, String> translations = generateTranslations(
      json['translations'],
      json['__str__'],
    );

    return Tag(
      id: json['id'],
      translations: translations,
    );
  }

  String? get name {
    return translations?['en'];
  }
}
