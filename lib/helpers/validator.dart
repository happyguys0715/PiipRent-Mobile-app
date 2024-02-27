bool isValidEmail(String? value) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value!);
}

bool isValidPhoneNumber(String? value) {
  return RegExp(r"^(\+)?[0-9]{10,14}$").hasMatch(value!);
}

String? emailValidator(String? value) {
  if (isValidEmail(value!)) {
    return null;
  }
  
  return 'Please enter a valid email!';
}

String? usernameValidator(String? value) {
  
  if (value!.isEmpty) {
    return 'Please input email address or phone number';
  }

  if (isValidEmail(value)) {
    return null;
  }

  if (isValidPhoneNumber(value)) {
    return null;
  }

  return 'Invalid email address or phone number';
}

String? numberValidator(String? value) {
  try {
    double.parse(value!);

    return null;
  } catch (e) {
    return 'Please enter a valid number!';
  }
}

String? requiredValidator(dynamic value) {
  if (value != null && value != '') {
    return null;
  }

  return 'This field is required';
}

String? emptyValidator(List<dynamic>? value) {
  if (value!.isNotEmpty) {
    return null;
  }

  return 'This field is required';
}
