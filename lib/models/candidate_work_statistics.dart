class CandidateWorkState {
  String? id;
  String? sStr;
  int? shiftsTotal;
  HourlyWork? hourlyWork;
  FiboBauroc? fiboBauroc;
  BaurocElement? baurocElement;
  Decorative? decorative;
  SkillActivities? skillActivities;
  String? currency;

  CandidateWorkState(
      { this.id,
        this.sStr,
        this.shiftsTotal,
        this.hourlyWork,
        this.fiboBauroc,
        this.baurocElement,
        this.decorative,
        this.skillActivities,
        this.currency});

  CandidateWorkState.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sStr = json['__str__'];
    shiftsTotal = json['shifts_total'];
    hourlyWork = (json['hourly_work'] != null
        ? new HourlyWork.fromJson(json['hourly_work'])
        : null);
    fiboBauroc = (json['skill_activities']['Fibo/Bauroc block laying by m2'] != null
    ? new FiboBauroc.fromJson(json['skill_activities']['Fibo/Bauroc block laying by m2'])
    : null);
    baurocElement = (json['skill_activities']['Bauroc Element laying by m2'] != null
    ? new BaurocElement.fromJson(json['skill_activities']['Bauroc Element laying by m2'])
    : null);
    decorative = (json['skill_activities']['Decorative render layer'] != null
    ? new Decorative.fromJson(json['skill_activities']['Decorative render layer'])
    : null);
    skillActivities = (json['skill_activities'] != null
        ? new SkillActivities.fromJson(json['skill_activities'])
        : null);
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['__str__'] = this.sStr;
    data['shifts_total'] = this.shiftsTotal;
    if (this.hourlyWork != null) {
      data['hourly_work'] = this.hourlyWork?.toJson();
    }
    if (this.fiboBauroc != null) {
      data['fibo_bauroc'] = this.fiboBauroc?.toJson();
    }
    if (this.baurocElement != null) {
      data['bauroc_element'] = this.baurocElement?.toJson();
    }
    if (this.decorative != null) {
      data['decorative'] = this.decorative?.toJson();
    }
    if (this.skillActivities != null) {
      data['skill_activities'] = this.skillActivities?.toJson();
    }
    data['currency'] = this.currency;
    return data;
  }
}

class HourlyWork {
  double? totalHours;
  int? totalMinutes;
  double? totalEarned;

  HourlyWork({this.totalHours, this.totalMinutes, this.totalEarned});

  HourlyWork.fromJson(Map<String, dynamic> json) {
    totalHours = json['total_hours'];
    totalMinutes = json['total_minutes'];
    totalEarned = double.parse(json['total_earned'].toDouble().toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_hours'] = this.totalHours;
    data['total_minutes'] = this.totalMinutes;
    data['total_earned'] = this.totalEarned;
    return data;
  }
}

class FiboBauroc {
  dynamic amount;
  double? totalEarned;

  FiboBauroc({this.amount, this.totalEarned});

  FiboBauroc.fromJson(Map<String, dynamic> json) {
    amount = json['value_sum'];
    totalEarned = double.parse(json['earned_sum'].toDouble().toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['total_earned'] = this.totalEarned;
    return data;
  }
}

class BaurocElement {
  double? amount;
  double? totalEarned;

  BaurocElement({this.amount, this.totalEarned});

  BaurocElement.fromJson(Map<String, dynamic> json) {
    amount = json['value_sum'];
    totalEarned = double.parse(json['earned_sum'].toDouble().toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['total_earned'] = this.totalEarned;
    return data;
  }
}

class Decorative {
  double? amount;
  double? totalEarned;

  Decorative({this.amount, this.totalEarned});

  Decorative.fromJson(Map<String, dynamic> json) {
    amount = json['value_sum'];
    totalEarned = double.parse(json['earned_sum'].toDouble().toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['total_earned'] = this.totalEarned;
    return data;
  }
}

class SkillActivities {
  String? currency;
  double? totalEarned;

  SkillActivities({this.totalEarned, this.currency});

  SkillActivities.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    totalEarned = double.parse(json['total_earned'].toDouble().toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_earned'] = this.totalEarned;
    data['currency'] = this.currency;
    return data;
  }
}
