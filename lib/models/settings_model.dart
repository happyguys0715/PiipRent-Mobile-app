class Settings {
  final String? id;
  final String? countryCode;
  final String? company;
  final String? formId;

  Settings({
    this.id,
    this.countryCode,
    this.company,
    this.formId,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      id: json['id'],
      countryCode: json['country_code'],
      company: json['company'],
      formId: json['register_form_id'],
    );
  }
}
