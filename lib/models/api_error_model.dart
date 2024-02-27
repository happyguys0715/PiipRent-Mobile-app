class ApiError {
  final String? status;
  final Map<String, dynamic>? errors;
  final List<dynamic>? messages;

  ApiError({
    this.status,
    this.errors,
    this.messages,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> errors = json['errors'];

    return ApiError(
      status: json['status'],
      errors: errors,
      messages: errors.values.map((element) {
        return element;
      }).toList(),
    );
  }
}
