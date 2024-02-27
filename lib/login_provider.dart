import 'package:flutter/cupertino.dart';
import 'package:piiprent/screens/preview_screen.dart';

class LoginProvider extends ChangeNotifier {
  var cacheManager = CustomCacheManager.instance;
  int _switchRole = 0;
  
  int get switchRole => _switchRole;

  set switchRole(int val) {
    _switchRole = val;
    notifyListeners();
  }

  String? _image;

  String get image {
    if (_image != null) {
      return _image!;
    } else {
      return ''; // Return an empty string or handle the case where _image is null
    }
  }

  set image(String? value) {
    _image = value;
    notifyListeners();
  }
}
