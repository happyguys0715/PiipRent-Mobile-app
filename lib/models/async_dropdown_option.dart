import 'package:flutter/cupertino.dart';

class AsyncDropdownOption {
  final String id;
  final String label;
  final String translateKey;

  const AsyncDropdownOption({
    required this.id,
    required this.label,
    required this.translateKey,
  });

  String get name {
    return translateKey ?? label;
  }
}
