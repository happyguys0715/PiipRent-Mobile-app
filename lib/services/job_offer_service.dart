import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiprent/models/job_offer_model.dart';
import 'package:piiprent/services/api_service.dart';

class JobOfferService {
  final ApiService apiService = ApiService.create();

  Future getCandidateJobOffers([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'status': '0',
      'fields': JobOffer.requestFields,
    };

    if (query != null) {
      params = {...params, ...query};
    }

    http.Response res =
        await apiService.get(path: '/hr/joboffers-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      List<dynamic> results = body['results'];
      List<JobOffer> jobOffers =
          results.map((dynamic el) => JobOffer.fromJson(el)).toList();

      return {"list": jobOffers, "count": body["count"]};
    } else {
      throw Exception('Failed to load Job Offers');
    }
  }

  Future<int> getCandidateJobOffersCount() async {
    Map<String, dynamic> params = {
      'status': '0',
      'limit': '-1',
      'fields': ['id']
    };

    http.Response res =
        await apiService.get(path: '/hr/joboffers-candidate/', params: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
      int count = body['count'];

      return count;
    } else {
      throw Exception('Failed to load Job Offers Count');
    }
  }

  Future<bool> accept(String id) async {
    Map<String, dynamic> body = Map();

    http.Response res = await this
        .apiService
        .post(path: '/hr/joboffers/$id/accept/', body: body);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to accept Job Offer');
    }
  }

  Future decline(String id) async {
    Map<String, dynamic> body = Map();

    http.Response res = await this
        .apiService
        .post(path: '/hr/joboffers/$id/cancel/', body: body);

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to decline Job Offer');
    }
  }
}
