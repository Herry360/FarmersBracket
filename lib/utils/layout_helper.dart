import 'package:flutter/material.dart';

class LayoutHelper {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    if (isLargeScreen(context)) return 4;
    if (isMediumScreen(context)) return 3;
    return 2;
  }

  static double getProductImageAspectRatio(BuildContext context) {
    if (isLargeScreen(context)) return 1.1;
    if (isMediumScreen(context)) return 1.0;
    return 0.9;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isLargeScreen(context)) {
      return const EdgeInsets.symmetric(horizontal: 64, vertical: 16);
    } else if (isMediumScreen(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
    }
  }

  static double getResponsiveFontSize(
    BuildContext context, {
    double small = 14,
    double medium = 16,
    double large = 18,
  }) {
    if (isLargeScreen(context)) return large;
    if (isMediumScreen(context)) return medium;
    return small;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double getResponsiveValue(
    BuildContext context, {
    double small = 1,
    double medium = 1.2,
    double large = 1.5,
  }) {
    if (isLargeScreen(context)) return large;
    if (isMediumScreen(context)) return medium;
    return small;
  }
}
