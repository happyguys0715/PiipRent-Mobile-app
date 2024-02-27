import 'package:piiprent/helpers/enums.dart';
import 'package:piiprent/models/role_model.dart';

class User {
  String? name;
  String? email;
  RoleType? type;
  Map<String, dynamic>? picture;
  String? id;
  String? userId;
  List<Role>? roles;
  String? candidateId;
  String? companyName;

  User({
    this.name,
    this.email,
    this.type,
    this.picture,
    this.id,
    this.userId,
    this.candidateId,
    this.companyName
  });

  factory User.fromTokenPayload(Map<String, dynamic> payload) {
    if (payload['contact'] == null) {
      throw 'Error';
    }

    var contact = payload['contact'][0];
    
    return User(
      name: contact['name'],
      email: contact['email'],
      type: getRole(contact['contact_type']),
      picture: contact['picture'],
      id: contact['contact_id'],
      userId: contact['id'],
      candidateId: contact['candidate_contact'],
      companyName: contact["company"]
    );
  }

  String? userAvatarUrl() {
    if (picture != null && picture!['origin'] != null) {
      return picture!['origin'];
    }

    return null;
  }

  Role? get activeRole {
    if (roles != null) {
      return roles?.firstWhere((element) => element.active);
    }

    return null;
  }
}

/*class User {
  User({
    this.userId,
    this.name,
    this.type,
    this.contactId,
    this.picture,
    this.email,
    this.str,
    this.company,
    this.companyId,
    this.candidateContact,
    this.defaultLanguage,
    this.roles,
  });

  String userId;
  String name;
  RoleType type;
  String contactId;
  Picture picture;
  String email;
  String str;
  String company;
  String companyId;
  dynamic candidateContact;
  String defaultLanguage;
  List<Role> roles;


  factory User.fromTokenPayload(Map<String, dynamic> json) => User(
    userId: json["id"],
    name: json["name"],
    type: getRole(json['contact_type']),
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
    "id": userId,
    "name": name,
    "contact_type": type,
    "contact_id": contactId,
    "picture": picture.toJson(),
    "email": email,
    "__str__": str,
    "company": company,
    "company_id": companyId,
    "candidate_contact": candidateContact,
    "default_language": defaultLanguage,
  };
  // String userAvatarUrl() {
  //   if (picture != null && picture['origin'] != null) {
  //     return picture['origin'];
  //   }
  //
  //   return null;
  // }

  Role get activeRole {
    if (roles != null) {
      return roles.firstWhere((element) => element.active);
    }

    return null;
  }
}*/

RoleType getRole(String contactType) {
  switch (contactType) {
    case 'candidate':
      return RoleType.Candidate;
    case 'client':
      return RoleType.Client;
    case 'manager':
      return RoleType.Manager;
    default:
      throw 'Unknown role';
  }
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
