
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;

  void init(BoxConstraints constraints, Orientation orientation) {
    
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
    }

    double ratioMultiplier = 1.0;
    double ratio = _screenHeight / _screenWidth * 9;

    if (ratio >= 18) {
      ratioMultiplier = 0.7;
    }
    
    // print('ScreenRatio: $_screenWidth x $_screenHeight = $ratio, Multiplier: $ratioMultiplier');

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight * ratioMultiplier / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
  }
}
