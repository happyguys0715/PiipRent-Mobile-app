import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:piiprent/models/country_model.dart';
import 'package:piiprent/services/api_service.dart';
import 'package:iso_countries/iso_countries.dart' as ISOCountry;

class CountryService {
  final ApiService apiService = ApiService.create();

  Future<List<Country>> getCountries([Map<String, dynamic>? query]) async {
    Map<String, dynamic> params = {
      'fields': Country.requestFields,
      'limit': '-1'
    };

    if (query != null) {
      params = {...params, ...query};
    }
    
    try {
      
      http.Response res =
          await apiService.get(path: '/core/countries/', params: params);

      var isoCountries = await getIsoCountries();

      if (res.statusCode == 200) {
        Map<String, dynamic> body = json.decode(utf8.decode(res.bodyBytes));
        List<dynamic> results = body['results'];
        
        List<Country> countries = results
            .map((dynamic el) => Country.fromJson(isoCountries, el))
            .toList();

        return countries;
      } else {
        throw Exception('Failed to load Countries');
      }
    } catch (e) {
      throw Exception('Failed to load Countries');
    }
  }

  Future<Map<String, String>> getIsoCountries() async {
    var locale = Get.locale;
    String localeIndetifier = '${locale?.languageCode}-${locale?.languageCode}';
    List<ISOCountry.Country> isoCountries =
        await ISOCountry.IsoCountries.isoCountriesForLocale(
            localeIndetifier);

    Map<String, String> countryMap = {};

    isoCountries.forEach((element) {
      countryMap[element.countryCode] = element.name;
    });

    return countryMap;
  }
}
