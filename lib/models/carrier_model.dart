class Carrier {
  final DateTime? targetDate;
  final bool? confirmedAvailable;
  final String? id;
  final DateTime? targetDateUtc;

  static final requestFields = [
    'target_date',
    'confirmed_available',
    'id',
  ];

  Carrier({
    this.targetDate,
    this.confirmedAvailable,
    this.id,
    this.targetDateUtc,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) {
    DateTime targetDate = DateTime.parse(json['target_date']);
    DateTime targetDateUtc = DateTime.utc(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    return Carrier(
      targetDate: targetDate,
      confirmedAvailable: json['confirmed_available'],
      id: json['id'],
      targetDateUtc: targetDateUtc,
    );
  }
}
