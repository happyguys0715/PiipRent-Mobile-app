import 'package:piiprent/models/contact_model.dart';

class ClientContact {
  final String? id;
  final Contact? contact;
  final String? jobTitle;
  final String? company;

  ClientContact({
    this.id,
    this.contact,
    this.jobTitle,
    this.company,
  });

  factory ClientContact.fromJson(Map<String, dynamic> json) {
    return ClientContact(
      id: json['id'],
      contact: Contact.fromJson(json['contact']),
      jobTitle: json['job_title'],
      company: json['company']['__str__'],
    );
  }

  String? get avatar {
    return contact?.userAvatarUrl();
  }

  String get fullName {
    return contact!.fullName;
  }

  String get email {
    return contact!.email!;
  }

  String get phone {
    return contact!.phoneMobile!;
  }
}
