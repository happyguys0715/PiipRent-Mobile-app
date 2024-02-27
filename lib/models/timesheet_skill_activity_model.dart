class TimesheetSkillActivity {
  String? id;
  String? timezone;
  String? name;

  TimesheetSkillActivity({
    this.id,
    this.name,
    this.timezone,
  });

  factory TimesheetSkillActivity.fromJson(Map<String, dynamic> payload) {
    return TimesheetSkillActivity(
      id: payload['id'],
      name: payload['name'],
      timezone: payload['timezone'],
    );
  }
}
