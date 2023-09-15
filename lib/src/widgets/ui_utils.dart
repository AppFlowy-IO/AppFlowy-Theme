import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderSize {
  static const double h1 = 12;
  static const double h2 = 16;
  static const double h3 = 20;
  static const double h4 = 24;
  static const double h5 = 32;
  static const double h6 = 36;
}

class IconSize {
  static const double size_8 = 8;
  static const double size_12 = 12;
  static const double size_16 = 16;
  static const double size_20 = 20;
  static const double size_24 = 24;
  static const double size_32 = 32;
}

class FontText {
  static const TextStyle font_12 = TextStyle(fontSize: 12);
  static const TextStyle font_14 = TextStyle(fontSize: 14);
  static const TextStyle font_16 = TextStyle(fontSize: 16);
  static const TextStyle font_18 = TextStyle(fontSize: 18);
  static const TextStyle font_20 = TextStyle(fontSize: 20);
  static const TextStyle font_24 = TextStyle(fontSize: 24);
}

class FontSize {
  static const double xs = 8;
  static const double s = 12;
  static const double m = 16;
  static const double l = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

class ContentPadding {
  static const double padding_4 = 4;
  static const double padding_8 = 8;
  static const double padding_12 = 12;
  static const double padding_16 = 16;
  static const double padding_20 = 20;
  static const double padding_24 = 24;
}

class ContentSpacer {
  static const Widget verticalSpacer_16 = SizedBox(height: 16);
  static const Widget verticalSpacer_24 = SizedBox(height: 24);
  static const Widget verticalSpacer_32 = SizedBox(height: 32);
  static const Widget verticalSpacer_48 = SizedBox(height: 48);
  static const Widget verticalSpacer_64 = SizedBox(height: 64);
  
  static const Widget horizontalSpacer_16 = SizedBox(width: 16);
  static const Widget horizontalSpacer_24 = SizedBox(width: 24);
  static const Widget horizontalSpacer_32 = SizedBox(width: 32);
  static const Widget horizontalSpacer_48 = SizedBox(width: 48);
  static const Widget horizontalSpacer_64 = SizedBox(width: 64);
}

enum ScreenSize{
  small(size: 420,numCards: 1),
  medium(size: 600, numCards: 2),
  large(size: 1000, numCards: 3),
  largest(size: 1001, numCards: 5);

  const ScreenSize({
    required this.size,
    required this.numCards,
  });

  final int size;
  final int numCards;
  
  factory ScreenSize.from(double size) {
    for (final value in ScreenSize.values) {
      if (size < value.size) return value;
     }
    return largest;
  }
}


class UiUtils {

  static const String lightJsonTheme = '.light.json';
  static const String darkJsonTheme = '.dark.json';
  static const String plugins = '.plugin';

  static const String defaultEmail = 'Guest@appflowy.io';
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
  static const Color gray = Color.fromRGBO(66, 66, 66, 1);
  static const Color blue = Colors.blue;
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  static const double leftNavBarWidth = 300;
  static const double borderWidth_1 = 1;

  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return(formatter.format(date).toString());
  }

  static double calculateCardSize(double screenSize) {
    if (screenSize < screenSizeSmall) {
      return screenSize;
    } else if (screenSize < screenSizeMedium) {
      return screenSize / 2;
    } else if (screenSize < screenSizeLarge) {
      return screenSize / 3;
    } else {
      return screenSize / 5;
    }
  }

  static int calCardsPerpage(double screenSize) {
    if (screenSize < screenSizeSmall) {
      return 1;
    } else if (screenSize < screenSizeMedium) {
      return 2;
    } else if (screenSize < screenSizeLarge) {
      return 3;
    } else {
      return 5;
    }
  }

  static String screenType(double screenSize) {
    if (screenSize < screenSizeSmall) {
      return 'S';
    } else if (screenSize < screenSizeMedium) {
      return 'M';
    } else if (screenSize < screenSizeLarge) {
      return 'L';
    } else {
      return 'XL';
    }
  }

  static Future<void> delayLoading([int milliseconds = 300]) async {
    await Future.delayed(Duration(milliseconds: milliseconds), () {});
  }

  static String defaultUsername(String email) {
    return email.split('@')[0];
  }
}
