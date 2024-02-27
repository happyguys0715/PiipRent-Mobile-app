class Tracking {
  DateTime? logAt;
  double? latitude;
  double? longitude;

  Tracking({
    this.logAt,
    this.latitude,
    this.longitude,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      logAt: DateTime.parse(json['log_at']),
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
