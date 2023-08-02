import 'package:flutter/material.dart';

class HeaderSize {
  static const double h1 = 12;
  static const double h2 = 14;
  static const double h3 = 16;
  static const double h4 = 20;
  static const double h5 = 24;
  static const double h6 = 32;
}

class IconSize {
  static const double xs = 8;
  static const double s = 12;
  static const double m = 16;
  static const double l = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

class TextSize {
  static const double xs = 8;
  static const double s = 12;
  static const double m = 16;
  static const double l = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

class FontSize {
  static const double xs = 8;
  static const double s = 12;
  static const double m = 16;
  static const double l = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

class UiUtils {
  static const double screenSizeSmall = 420;
  static const double screenSizeMedium = 600;
  static const double screenSizeLarge = 1000;
  
  static const double sizeXS = 4;
  static const double sizeS = 8;
  static const double sizeM = 12;
  static const double sizeL = 16;
  static const double sizeXL = 24;
  static const double sizeXXL = 32;
  
  static const Color color = Colors.black;  
  static const Color blue = Colors.blue;
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  
  static double calculateCardSize(double screenSize) {
    if(screenSize < screenSizeSmall)
      return screenSize;
    else if(screenSize < screenSizeMedium)
      return screenSize / 2;
    else if(screenSize < screenSizeLarge)
      return screenSize / 3;
    else
      return screenSize / 5;
  }

  static String screenType(double screenSize){
    if(screenSize < screenSizeSmall)
      return 'S';
    else if(screenSize < screenSizeMedium)
      return 'M';
    else if(screenSize < screenSizeLarge)
      return 'L';
    else
      return 'XL';
  }

  static Future<void> delayLoading([int milliseconds = 300]) async {
    await Future.delayed(Duration(milliseconds: milliseconds), () {});
  }
}