import 'package:flutter/cupertino.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';

CommonTextClass commonText = CommonTextClass();

class CommonTextClass {
  Widget regular({text, height, overflow, textAlign, shadows, maxLines, fontSize, textColor, decoration, decorationColor,fontWeight,fontFamily}) {
    return Text(
      text,
      textScaler: TextScaler.linear(1.0),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        height: height,
        shadows: shadows,
        fontSize: fontSize ?? 14.0,
        color: textColor ?? color.black,
        fontWeight: fontWeight??FontWeight.w400,
        decoration: decoration,
        fontFamily: fontFamily??'Regular',
        decorationColor: decorationColor,
      ),
    );
  }

  Widget medium({text, height, maxLines, shadows, overflow, textAlign, fontSize, textColor, decoration, decorationColor}) {
    return Text(
      text ?? "",
      textScaler: TextScaler.linear(1.0),
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 3,
      style: TextStyle(
        height: height,
        shadows: shadows,
        fontSize: fontSize ?? MySize.getScaledSizeHeight(14),
        color: textColor ?? color.black,
        fontWeight: FontWeight.w500,
        decoration: decoration,
        fontFamily: 'Medium',
        decorationColor: decorationColor,
      ),
    );
  }

  Widget semiBold({text, height, overflow, textAlign, shadows, maxLines, fontSize, textColor, decoration}) {
    return Text(
      text,
      textScaler: TextScaler.linear(1.0),
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 3,
      style: TextStyle(
        height: height,
        shadows: shadows,
        fontSize: fontSize ??MySize.getScaledSizeHeight(14),
        color: textColor ?? color.black,
        fontWeight: FontWeight.w600,
        decoration: decoration,
        fontFamily: 'SemiBold',
      ),
    );
  }

  Widget bold({text, height, overflow, textAlign, shadows, maxLines, fontSize, tColor, decoration}) {
    return Text(
      text,
      textScaler: TextScaler.linear(1.0),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        height: height,
        shadows: shadows,
        fontSize: fontSize ?? MySize.getScaledSizeHeight(14),
        color: tColor ?? color.black,
        fontWeight: FontWeight.w700,
        decoration: decoration,
        fontFamily: 'Bold',
      ),
    );
  }

  Widget roseBold({text, height, overflow, textAlign, shadows, maxLines, fontSize, tColor, decoration}) {
    return Text(
      text,
      textScaler: TextScaler.linear(1.0),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        height: height,
        shadows: shadows,
        fontSize: fontSize ?? MySize.getScaledSizeHeight(14),
        color: tColor ?? color.white,
        fontWeight: FontWeight.w700,
        decoration: decoration,
        fontFamily: 'RoseBold',
      ),
    );
  }
}
