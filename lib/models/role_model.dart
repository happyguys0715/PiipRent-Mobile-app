class Role {
  final String? id;
  final String? name;
  final String? company;
  final String? jobTitle;

  bool active = false;

  static final requestFields = [
    'id',
    '__str__',
  ];

  Role({
    this.id,
    this.name,
    this.company,
    this.jobTitle,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: (json['__str__'] as String).split('-')[0].trim(),
      company: (json['__str__'] as String).split('-')[1].trim(),
      jobTitle: json['job_title'],
    );
  }
}

class RoleSwitchUser {
  RoleSwitchUser({
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
  bool? active = true;

  factory RoleSwitchUser.fromJson(Map<String, dynamic> json) => RoleSwitchUser(
        id: json["id"],
        name: json["name"],
        companyContactRel:
            CompanyContactRel.fromJson(json["company_contact_rel"]),
        str: json["__str__"],
        domain: json["domain"],
        isActive: json["is_active"] ?? false,
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

  factory CompanyContactRel.fromJson(Map<String, dynamic> json) =>
      CompanyContactRel(
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
