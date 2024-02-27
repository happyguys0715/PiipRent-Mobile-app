import 'package:piiprent/helpers/functions.dart';

class AverageScores {
  final double? clientFeedback;
  final double? reliability;
  final double? loyality;
  final double? recruitmentScore;
  final double? skillScore;

  static final requestFields = [
    'client_feedback',
    'reliability',
    'loyalty',
    'recruitment_score',
    'skill_score',
  ];

  AverageScores({
    this.clientFeedback,
    this.reliability,
    this.loyality,
    this.recruitmentScore,
    this.skillScore,
  });

  factory AverageScores.fromJson(Map<String, dynamic> json) {
    return AverageScores(
      clientFeedback: doubleParse(json['client_feedback']),
      reliability: doubleParse(json['reliability']),
      loyality: doubleParse(json['loyalty']),
      recruitmentScore: doubleParse(json['recruitment_score']),
      skillScore: doubleParse(json['skill_score']),
    );
  }
}
