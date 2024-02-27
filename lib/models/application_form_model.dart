class ApplicationForm {
  final Map<String, bool>? config;

  ApplicationForm({
    this.config,
  });

  factory ApplicationForm.fromJson(Map<String, dynamic> json) {
    List<dynamic> config = json['ui_config'];
    Map<String, bool> configMap = Map();

    config.forEach((el) {
      final required = el['templateOptions'] != null
          ? el['templateOptions']['required'] as bool
          : false;

      configMap.addAll({'${el['key']}': required});
    });

    return ApplicationForm(
      config: configMap,
    );
  }

  bool isExist(List<String> keys) {
    return keys.any((element) => this.config!.containsKey(element));
  }

  bool isRequired(String key) {
    return this.config!.containsKey(key) && this.config![key]!;
  }
}
