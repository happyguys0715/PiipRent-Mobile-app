class Shift {
  final String? id;
  final DateTime? datetime;
  final int? workers;
  final bool? isFulfilled;
  final String? jobsite;
  final DateTime? date;
  final bool? pending;

  static List<String> requestFields = const [
    'id',
    'date',
    'time',
    'workers',
    'is_fulfilled',
    'workers_details',
  ];

  Shift(
      {
      this.id,
      this.datetime,
      this.workers,
      this.isFulfilled,
      this.jobsite,
      this.date,
      this.pending,
      });

  factory Shift.fromJson(Map<String, dynamic> json) {
    var datetime =
        DateTime.parse("${json['date']['shift_date']}T${json['time']}");
    var date = DateTime.utc(
      datetime.year,
      datetime.month,
      datetime.day,
    );

    return Shift(
      id: json['id'],
      workers: json['workers'],
      isFulfilled: json['is_fulfilled'] == 1 ? true : false,
      datetime: datetime,
      date: date,
      jobsite: 'Jobsite',
      pending: json['workers_details']['undefined'] == 1 ? true : false,
    );
  }
}
