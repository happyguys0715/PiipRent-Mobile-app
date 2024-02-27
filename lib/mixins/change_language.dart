import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

mixin ChangeLanguage {
  void showDemoActionSheet({required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then(
      (String value) {
        changeLocale(context, value);
        var locale = Locale(value, '');
        Get.updateLocale(locale);
      } as FutureOr Function(String? value),
    );
  }

  void onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(translate('language.selection.title')),
        message: Text(translate('language.selection.message')),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.name.en')),
            onPressed: () => Navigator.pop(context, 'en'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.et')),
            onPressed: () => Navigator.pop(context, 'et'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.fi')),
            onPressed: () => Navigator.pop(context, 'fi'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.ru')),
            onPressed: () => Navigator.pop(context, 'ru'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate('button.cancel')),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }
}
