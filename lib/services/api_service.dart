import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piiprent/constants.dart';
import 'package:piiprent/models/auth_model.dart';

ApiService? instance;

class ApiService {
  final String _baseUrl = apiUrl.replaceAll('https://', '');
  Auth? _auth;
  final Map<String, dynamic> _emptyMap = Map();

  Auth? get auth {
    return _auth;
  }

  set auth(Auth? auth) {
    this._auth = auth;
  }

  ApiService();

  factory ApiService.create() {
    if (instance != null) {
      return instance!;
    } else {
      instance = ApiService();
      return instance!;
    }
  }

  Future get({required String path, required Map<String, dynamic> params}) async {
    Uri uri = _createURI(path, params);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // TODO: check this for getting industries or skills
      'Origin': origin
    };
    _updateByToken(headers);
    // debugPrint('GET URL:: $uri');
    var res = await http.get(uri, headers: headers);
    // debugPrint('\n ======= \n Response:: ${res.body}');
    // debugPrint('\n ======= \n GET URL:: $uri \nHeader : ${headers.toString()} \n\nResponse:: ${res.body}');
    return res;
  }

  Future post({required String path, required Map<String, dynamic> body}) async {
    Uri uri = _createURI(path, _emptyMap);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Origin': origin,
      // 'Cookie': 'sessionid=vop55wzfz859b8lz65k5qz9f6lzw2zwy'
    };
    _updateByToken(headers);

    // debugPrint('POST Header:: $headers');

    String bodyEncoded = json.encode(body);

    // debugPrint('POST URL:: $uri');
    
    var res = await http.post(uri, headers: headers, body: bodyEncoded);
    // debugPrint('POST URL:: $uri Response:: ${res.body}');

    return res;
  }

  Future put({required String path, required Map<String, dynamic> body}) async {
    Uri uri = _createURI(path, _emptyMap);
    Map<String, String> headers = {
      // 'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Origin': origin
    };
    _updateByToken(headers);

    String bodyEncoded = json.encode(body);

    return await http.put(uri, headers: headers, body: bodyEncoded);
  }

  Future patch({required String path, required Map<String, dynamic> body}) async {
    Uri uri = _createURI(path, _emptyMap);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Origin': origin
    };
    _updateByToken(headers);

    String bodyEncoded = json.encode(body);

    return await http.patch(uri, headers: headers, body: bodyEncoded);
  }

  Future delete({required String path}) async {
    Uri uri = _createURI(path, _emptyMap);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Origin': origin
    };
    _updateByToken(headers);

    return await http.delete(uri, headers: headers);
  }

  Future uploadFile({required String path, required Map<String, dynamic> fields, required String fileField, required String filePath}) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Origin': origin
    };
    _updateByToken(headers);
    
    Uri uri = _createURI(path, _emptyMap);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    
    fields.forEach((k, v) => request.fields[k] = v);

    var file = await http.MultipartFile.fromPath(fileField, filePath);
    request.files.add(file);

    await request.send().then((result) {
      http.Response.fromStream(result).then((response) {
        var message = jsonDecode(response.body);
        print(message);
      });
    });    
  }

  Uri _createURI(String path, Map<String, dynamic> params) {
    return Uri(
      scheme: 'https',
      host: _baseUrl,
      path: path,
      queryParameters: params,
    );
  }

  void _updateByToken(headers) {
    if (auth != null) {
      // debugPrint('JWT ${auth.access_token_jwt}');
      headers.addAll({
        HttpHeaders.authorizationHeader: 'JWT ${auth?.access_token_jwt}',
      });
    }
  }
}
