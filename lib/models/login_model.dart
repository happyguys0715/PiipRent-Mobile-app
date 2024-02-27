// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.contact,
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.scope,
    this.refreshToken,
    this.accessTokenJwt,
  });

  Contact? contact;
  String? accessToken;
  int? expiresIn;
  String? tokenType;
  String? scope;
  String? refreshToken;
  String? accessTokenJwt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    contact: Contact.fromJson(json["contact"]),
    accessToken: json["access_token"],
    expiresIn: json["expires_in"],
    tokenType: json["token_type"],
    scope: json["scope"],
    refreshToken: json["refresh_token"],
    accessTokenJwt: json["access_token_jwt"],
  );

  Map<String, dynamic> toJson() => {
    "contact": contact?.toJson(),
    "access_token": accessToken,
    "expires_in": expiresIn,
    "token_type": tokenType,
    "scope": scope,
    "refresh_token": refreshToken,
    "access_token_jwt": accessTokenJwt,
  };
}

class Contact {
  Contact({
    this.id,
    this.name,
    this.contactType,
    this.contactId,
    this.picture,
    this.email,
    this.str,
    this.company,
    this.companyId,
    this.candidateContact,
    this.defaultLanguage,
  });

  String? id;
  String? name;
  String? contactType;
  String? contactId;
  Picture? picture;
  String? email;
  String? str;
  String? company;
  String? companyId;
  dynamic? candidateContact;
  String? defaultLanguage;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json["id"],
    name: json["name"],
    contactType: json["contact_type"],
    contactId: json["contact_id"],
    picture: Picture.fromJson(json["picture"]),
    email: json["email"],
    str: json["__str__"],
    company: json["company"],
    companyId: json["company_id"],
    candidateContact: json["candidate_contact"],
    defaultLanguage: json["default_language"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "contact_type": contactType,
    "contact_id": contactId,
    "picture": picture?.toJson(),
    "email": email,
    "__str__": str,
    "company": company,
    "company_id": companyId,
    "candidate_contact": candidateContact,
    "default_language": defaultLanguage,
  };
}

class Picture {
  Picture({
    this.thumb,
    this.origin,
  });

  String? thumb;
  String? origin;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    thumb: json["thumb"],
    origin: json["origin"],
  );

  Map<String, dynamic> toJson() => {
    "thumb": thumb,
    "origin": origin,
  };
}
