import 'package:flutter/material.dart';
import 'package:seo/src/seo_tag.dart';

extension TextStyleExtensions on TextStyle {
  TextTagStyle textTagStyle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (fontSize == textTheme.headline1?.fontSize) {
      return TextTagStyle.h1;
    } else if (fontSize == textTheme.headline2?.fontSize) {
      return TextTagStyle.h2;
    } else if (fontSize == textTheme.headline3?.fontSize) {
      return TextTagStyle.h3;
    } else if (fontSize == textTheme.headline4?.fontSize) {
      return TextTagStyle.h4;
    } else if (fontSize == textTheme.headline5?.fontSize) {
      return TextTagStyle.h5;
    } else if (fontSize == textTheme.headline6?.fontSize) {
      return TextTagStyle.h6;
    }

    return TextTagStyle.p;
  }
}
