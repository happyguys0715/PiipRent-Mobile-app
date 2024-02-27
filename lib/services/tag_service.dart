import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/tag_model.dart';
import 'package:piiprent/services/api_service.dart';

class TagService {
  final ApiService apiService = ApiService.create();

  Future<List<Tag>> getAllTags([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'fields': Tag.requestFields,
      'limit': '-1',
    };

    if (query != null) {
      params = {
        ...params,
        ...query,
      };
    }

    http.Response res = await apiService.get(
      path: '/core/tags/all/',
      params: params,
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<Tag> tags = results.map((dynamic el) => Tag.fromJson(el)).toList();

      return tags;
    } else {
      throw Exception('Failed to load Tags');
    }
  }
}
