class CompanyContact {
  final String? id;

  static List<String> requestFields = const [
    'id',
  ];

  CompanyContact({
    this.id,
  });

  factory CompanyContact.fromJson(Map<String, dynamic> json) {
    return CompanyContact(
      id: json['id'],
    );
  }
}
