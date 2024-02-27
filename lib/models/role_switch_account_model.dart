// To parse this JSON data, do
//
//     final switchAccountModel = switchAccountModelFromJson(jsonString);

import 'dart:convert';

SwitchAccountModel switchAccountModelFromJson(String str) => SwitchAccountModel.fromJson(json.decode(str));

String switchAccountModelToJson(SwitchAccountModel data) => json.encode(data.toJson());

class SwitchAccountModel {
  SwitchAccountModel({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory SwitchAccountModel.fromJson(Map<String, dynamic> json) => SwitchAccountModel(
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
    this.timezone,
    this.user,
    this.endTrialDate,
    this.isPrimary,
    this.roles,
    this.countryCode,
    this.countryPhonePrefix,
    this.allowJobCreation,
  });

  Contact? contact;
  String? timezone;
  String? user;
  EndTrialDate? endTrialDate;
  bool? isPrimary;
  List<Role>? roles;
  String? countryCode;
  String? countryPhonePrefix;
  bool? allowJobCreation;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    contact: Contact.fromJson(json["contact"]),
    timezone: json["timezone"],
    user: json["user"],
    endTrialDate: EndTrialDate.fromJson(json["end_trial_date"]),
    isPrimary: json["is_primary"],
    roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
    countryCode: json["country_code"],
    countryPhonePrefix: json["country_phone_prefix"],
    allowJobCreation: json["allow_job_creation"],
  );

  Map<String, dynamic> toJson() => {
    "contact": contact?.toJson(),
    "timezone": timezone,
    "user": user,
    "end_trial_date": endTrialDate?.toJson(),
    "is_primary": isPrimary,
    "roles": List<dynamic>.from(roles!.map((x) => x.toJson())),
    "country_code": countryCode,
    "country_phone_prefix": countryPhonePrefix,
    "allow_job_creation": allowJobCreation,
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
  String? candidateContact;
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

class EndTrialDate {
  EndTrialDate({
    this.user,
  });

  String? user;

  factory EndTrialDate.fromJson(Map<String, dynamic> json) => EndTrialDate(
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
  };
}

class Role {
  Role({
    this.id,
    this.name,
    this.companyContactRel,
    this.str,
    this.domain,
    this.isActive,
  });

  String? id;
  String? name;
  CompanyContactRel? companyContactRel;
  String? str;
  String? domain;
  dynamic? isActive;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
    companyContactRel: CompanyContactRel.fromJson(json["company_contact_rel"]),
    str: json["__str__"],
    domain: json["domain"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "company_contact_rel": companyContactRel?.toJson(),
    "__str__": str,
    "domain": domain,
    "is_active": isActive,
  };
}

class CompanyContactRel {
  CompanyContactRel({
    this.id,
    this.company,
    this.companyContact,
    this.str,
  });

  String? id;
  Company? company;
  Company? companyContact;
  String? str;

  factory CompanyContactRel.fromJson(Map<String, dynamic> json) => CompanyContactRel(
    id: json["id"],
    company: Company.fromJson(json["company"]),
    companyContact: Company.fromJson(json["company_contact"]),
    str: json["__str__"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company": company?.toJson(),
    "company_contact": companyContact?.toJson(),
    "__str__": str,
  };
}

class Company {
  Company({
    this.id,
    this.name,
    this.str,
    this.timezone,
  });

  String? id;
  String? name;
  String? str;
  String? timezone;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    str: json["__str__"],
    timezone: json["timezone"] == null ? null : json["timezone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "__str__": str,
    "timezone": timezone == null ? null : timezone,
  };
}
