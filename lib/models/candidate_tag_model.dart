import 'package:piiprent/models/tag_model.dart';

class CandidateTag {
  final String? id;
  final Tag? tag;

  static final requestFields = [
    'id',
    'tag',
  ];

  CandidateTag({
    this.id,
    this.tag,
  });

  factory CandidateTag.fromJson(Map<String, dynamic> json) {
    return CandidateTag(
      id: json['id'],
      tag: Tag.fromJson(json['tag']),
    );
  }
}
