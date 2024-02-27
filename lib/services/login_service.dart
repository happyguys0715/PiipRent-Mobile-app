import 'dart:convert';
import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piiprent/constants.dart';
import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/helpers/jwt_decode.dart';
import 'package:piiprent/login_provider.dart';
import 'package:piiprent/models/auth_model.dart';
import 'package:piiprent/models/role_model.dart';
import 'package:piiprent/models/user_model.dart';
import 'package:piiprent/services/api_service.dart';
import 'package:piiprent/services/contact_service.dart';
import 'package:piiprent/screens/auth/login_screen.dart';

class LoginService {
  final ApiService? apiService = ApiService.create();
  final ContactService contactService = ContactService();
  User? _user;

  User? get user {
    return _user;
  }

  // Future<dynamic> switchAccounts()async{
  //   // Map<String, dynamic> body = {
  //   //   'client_id': clientId,
  //   //   'username': username,
  //   //   'password': password,
  //   //   'grant_type': 'password'
  //   // };
  //   Map<String, dynamic> body = {
  //     // 'client_id': clientId,
  //     // 'username': username,
  //     // 'password': password,
  //     'grant_type': 'password'
  //   };
  //
  //   try {
  //     http.Response res =
  //         await apiService.post(path: '/auth/login/', body: body);
  //
  //     if (res.statusCode == 400) {
  //       throw 'Email or Password is not valid';
  //     }
  //
  //     if (res.statusCode != 200) {
  //       throw 'Something went wrong';
  //     }
  //
  //     Auth auth = Auth.fromJson(json.decode(utf8.decode(res.bodyBytes),),);
  //
  //     apiService.auth = auth;
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('auth', res.body);
  //
  //     var payload = parseJwtPayLoad(auth.access_token_jwt);
  //     _user = User.fromTokenPayload(payload);
  //
  //     return _user.type;
  //   } catch (e) {
  //     throw e?.toString() ?? 'Something went wrong';
  //   }
  // }

  Future<RoleType> login(
      {required BuildContext context,
      required String username,
      required String password}) async {

    Map<String, dynamic> body = {
      'client_id': clientId,
      'username': username,
      'password': password,
      'grant_type': 'password'
    };

    try {
      http.Response res =
          await apiService?.post(path: '/auth/login/', body: body);
      
      if (res.statusCode == 400) {
        throw 'Username or Password is not valid';
      }

      if (res.statusCode != 200) {
        throw 'Something went wrong';
      }

      Auth auth = Auth.fromJson(json.decode(utf8.decode(res.bodyBytes)));

      apiService?.auth = auth;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth', res.body);
      prefs.setString('username', username);
      
      var payload = parseJwtPayLoad(auth.access_token_jwt!);
            _user = User.fromTokenPayload(payload);
            List<Role> roles = await contactService.getRoles();
      roles[0].active = true;
      _user?.type = getRole(roles[0].name!);

      user?.roles = [];

      user?.roles?.addAll(roles);
      return _user!.type!;
    } catch (e) {
      throw e.toString() ?? 'Something went wrong';
    }
  }

  Future<RoleType?> getUser(BuildContext context) async {
    LoginProvider loginService =
        Provider.of<LoginProvider>(context, listen: false);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String authEncoded = (prefs.getString('auth') ?? '');

      if (authEncoded != '') {
        Auth auth = Auth.fromJson(json.decode(authEncoded));
        var payload = parseJwtPayLoad(auth.access_token_jwt!);
        DateTime expireDateTime =
            DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

        if (DateTime.now().isAfter(expireDateTime)) {
          var res = await refreshToken(auth);

          if (res != null) {
            auth = Auth.fromJson(json.decode(utf8.decode(res.bodyBytes)));
            apiService?.auth = auth;

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('auth', res.body);

            var payload = parseJwtPayLoad(auth.access_token_jwt!);
            _user = User.fromTokenPayload(payload);
          } else {
            await logout(context: context);
            return null;
          }
        } else {
          apiService?.auth = auth;
          _user = User.fromTokenPayload(payload);
        }

        //if (user.type == RoleType.Client) {
        List<Role> roles = await contactService.getRoles();
        roles[loginService.switchRole].active = true;
        _user?.type = getRole(roles[loginService.switchRole].name!);

        user?.roles = [];

        user?.roles?.addAll(roles);
        //}

        return _user?.type;
      } else {
        return null;
      }
    } catch (e) {
      await logout(context: context);
      return null;
    }
  }

  Future refreshToken(Auth auth) async {
    var payload = parseJwtPayLoad(auth.access_token_jwt!);
    User user = User.fromTokenPayload(payload);

    Map<String, String> body = {
      'username': user.email!,
      'grant_type': 'refresh_token',
      'refresh_token': auth.refresh_token!,
      'client_id': clientId,
    };

    try {
      http.Response res =
          await apiService?.post(path: '/oauth2/token/', body: body);

      if (res.statusCode == 200) {
        return res;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> logout({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BackgroundLocation.stopLocationService();
    
    // Keep username only to autofill it on log-in screen
    Object? username = prefs.get('username');
    prefs.clear();
    prefs.setString('username', username as String);
    
    _user = null;
    apiService?.auth = null;
    await deleteImageFromCache(context: context);
    return true;
  }
}
