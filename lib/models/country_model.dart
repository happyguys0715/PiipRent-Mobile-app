class Country {
  final String? id;
  final String? str;
  final String? code2;
  final Map<String, String> isoCountries;

  static final requestFields = [
    'id',
    '__str__',
    'code2',
  ];

  Country(countries, {this.id, this.str, this.code2})
      : isoCountries = countries;

  factory Country.fromJson(
    Map<String, String> isoCountries,
    Map<String, dynamic> json,
  ) {
    return Country(
      isoCountries,
      id: json['id'],
      str: json['__str__'],
      code2: json['code2'],
    );
  }

  String get name {
    return isoCountries[code2] ?? str!;
  }
}
