import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/theme_controller.dart';

class GFonts {
  static const russoOne = GoogleFonts.russoOne;
  static const openSans = GoogleFonts.openSans;
  static const chakraPetch = GoogleFonts.chakraPetch;
}

TextStyle gStyle({
  TextStyle Function()? fontFamily,
  FontWeight? weight,
  double? size,
  Color? color,
  double? height,
  double? letterSpacing,
  TextDecoration? decoration,
  Paint? foreground,
  List<Shadow>? shadows,
  FontStyle? fontStyle,
}) {
  final themeController = Get.find<ThemeController>();

  return (GFonts.chakraPetch)(
    fontWeight: weight ?? FontWeight.normal,
    fontSize: size,
    color: color ??
        (themeController.isDarkMode.value ? Colors.white : Colors.black87),
    height: height,
    letterSpacing: letterSpacing,
    decoration: decoration,
    foreground: foreground,
    shadows: shadows,
    fontStyle: fontStyle,
  );
}
