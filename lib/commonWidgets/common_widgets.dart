import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:radianthyve_unified/commonWidgets/commonSizebox.dart';
import 'package:radianthyve_unified/commonWidgets/common_text.dart';
import 'package:radianthyve_unified/utils/Img_Icon.dart';
import 'package:radianthyve_unified/utils/SizeConstant.dart';
import 'package:radianthyve_unified/utils/common_color.dart';

import 'constant.dart';

Widgets commonWidget = Widgets();

class Widgets {
  AppBar appBar({
    fontSize,
    title,
    leadingWidth,
    final List<Widget>? actions,
    Function()? onTap,
    leading,
    leadingIcon,
    centerTitle,
    titleSpacing,
    titleText,
    textColor,
    backgroundColor,
    double? toolbarHeight,
    Color? statusBarColor,
    statusBarIconBrightness,
    statusBarBrightness,
    iconColor,
  }) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? Colors.transparent,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        statusBarBrightness: statusBarBrightness ?? Brightness.light,
      ),
      leadingWidth: leadingWidth ?? MySize.getScaledSizeWidth(42),
      leading: leading ??
          Padding(
            padding: EdgeInsets.only(left: MySize.getScaledSizeWidth(16), top: MySize.getScaledSizeHeight(16)),
            child: InkWell(
              splashColor: color.transparentColor,
              highlightColor: color.transparentColor,
              onTap: onTap ??
                  () {
                    Get.back();
                    FocusScope.of(Get.context!).unfocus();
                  },
              child: Image.asset(
                icons.backIcon,
                height: MySize.getScaledSizeHeight(24),
                width: MySize.getScaledSizeWidth(24),
                color: iconColor ?? color.black,
              ),
            ),
          ),
      title: title ??
          commonText
              .medium(
                text: titleText ?? "",
                fontSize: fontSize ?? MySize.getScaledSizeHeight(18),
                textColor: textColor ?? color.black,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
              .paddingOnly(top: 16),
      centerTitle: centerTitle ?? true,
      elevation: 0.0,
      titleSpacing: titleSpacing,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor ?? color.white,
      actions: actions,
      toolbarHeight: toolbarHeight,
    );
  }

  Widget customButton({text, Function()? onTap, buttonColor, textColor, child, buttonHeight, margin, buttonWidth, padding, radius, cornerRadius, fontSize, side, gradient, isLoading = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: buttonHeight ?? 48,
          width: buttonWidth ?? Get.width,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: gradient == null ? (buttonColor ?? color.appColor) : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius ?? MySize.getScaledSizeHeight(8))
          ),
          child:
          (isLoading == true)
              ? CommonLoader(color: color.white, size: MySize.getScaledSizeHeight(30))
              : child ?? Center(child: commonText.medium(text: text, fontSize: fontSize ?? MySize.getScaledSizeHeight(16), textColor: textColor ?? Colors.white)),
        ),
      ),
    );
  }

  Future bottomSheet({required child, height, colors, radiusRight, radiusLeft, sheetColor, height2, Function()? onTap, closeWidget, backdropFilterFlag = 0}) {
    return showModalBottomSheet(
      context: Get.context!,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: backdropFilterFlag == 0 ? 0 : 8, sigmaY: backdropFilterFlag == 0 ? 0 : 8),
          child: Container(
            height: height,
            width: Get.width,
            decoration: BoxDecoration(
              color: colors ?? color.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(radiusRight ?? 20),
                topLeft: Radius.circular(radiusLeft ?? 20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MySize.getScaledSizeHeight(5)),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget commonDivider({double? height, Color? color}) {
    return Divider(
      color: color ?? Color(0xffDEDEDE),
      height: height ?? 1.0,
    );
  }

  Widget commonTextField({
    height,
    maxLines = 1,
    labelText,
    controller,
    fieldColor,
    String errorText = '',
    obscureText = false,
    TextInputType keyboardType = TextInputType.multiline,
    TextInputAction textInputAction = TextInputAction.next,
    onChanged,
    isValidField,
    hintText,
    Function()? onTap,
    Function()? validator,
    Widget? suffixIcon,
    Widget? prefixIcon,
    Widget? suffix,
    Widget? prefix,
    bool autoFocus = false,
    bool readOnly = false,
    int? maxLength,
    Color? backgroundColor,
    contentPadding,
    prefixText,
    final inputFormatters,
    final isbordervisibal,
    isKeyboardVisible,
    darkBorderColor,
    padding,
    textColor,
    textSize,
    prefixStyle,
    minLines,
    key,
    fillColor,
    expands,
    textAlign,
    scrollPhysics,
    focusNode,
    labelTextColor,
    width,
    errorBorder,
    isRemoveStare,
    button,
    isButton,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return KeyboardVisibilityBuilder(builder: (BuildContext context, bool isKeyboardVisible) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText == null
              ? const SizedBox()
              : Row(
                children: [
                  commonText.medium(
                      text: "$labelText",
                      textColor: labelTextColor ?? color.textFieldTextColor,
                      fontSize: MySize.getScaledSizeHeight(14),
                    ),
                  isRemoveStare == true
                      ? commonText.medium(
                    text: "*",
                    textColor: color.textFieldErrorColor,
                    fontSize: MySize.getScaledSizeHeight(16),
                  ) : SizedBox(),
                  Spacer(),
                  isButton == true ? button : SizedBox(),
                ],
              ),
          labelText == null ? const SizedBox() : SizedBox(height: MySize.getScaledSizeHeight(8)),
          MediaQuery(
            // data: MediaQuery.of(Get.context!).copyWith(textScaler: TextScaler.linear(MediaQuery.of(Get.context!).textScaleFactor.clamp(1.0, 1.0))),
            data: MediaQuery.of(Get.context!).copyWith(
              textScaleFactor: MediaQuery.of(Get.context!).textScaleFactor.clamp(1.0, 1.0),
            ),
            child: Container(
              width: width ?? Get.width,
              height: height ?? MySize.getScaledSizeHeight(48),
              padding: padding ?? EdgeInsets.symmetric(horizontal: MySize.getScaledSizeWidth(5)),
              decoration: BoxDecoration(
                color: fieldColor ?? color.white,
                border: Border.all(
                  color: (isKeyboardVisible && isbordervisibal)
                      ? color.textFieldFocusColor
                      : errorText == ''
                          ? color.onboardingBorderColor
                          : color.textFieldErrorColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(MySize.getScaledSizeHeight(8)),
              ),
              child: Align(
                alignment: maxLines > 1 ? Alignment.topCenter : Alignment.center,
                child: TextFormField(
                  onFieldSubmitted: onFieldSubmitted,
                  inputFormatters: inputFormatters,
                  maxLength: maxLength,
                  readOnly: readOnly,
                  expands: expands ?? false,
                  controller: controller,
                  onTap: onTap,
                  focusNode: focusNode,
                  scrollPhysics: scrollPhysics,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  obscuringCharacter: "●",
                  autofocus: autoFocus,
                  onChanged: onChanged,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  textAlign: textAlign ?? TextAlign.start,
                  decoration: InputDecoration(
                    prefixText: prefixText,
                    prefixStyle: prefixStyle,
                    isDense: true,

                    counterText: '',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: errorBorder,
                    disabledBorder: InputBorder.none,
                    contentPadding: contentPadding,
                    hintText: hintText,
                    hintStyle: TextStyle(fontSize: MySize.getScaledSizeHeight(14), color: color.onboardingTextColor, fontFamily: 'Regular'),
                    suffixIcon: suffixIcon,
                    prefixIcon: prefixIcon,
                    filled: true,
                    suffix: suffix,
                    fillColor: fillColor ?? color.transparentColor,
                    prefix: prefix,
                  ),
                  minLines: minLines ?? 1,
                  maxLines: maxLines,
                  style: TextStyle(
                    fontSize: textSize ?? MySize.getScaledSizeHeight(14),
                    color: textColor ?? color.black,
                    fontFamily: 'Medium',
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: color.black,
                ),
              ),
            ),
          ),
          errorText == ''
              ? const SizedBox()
              : commonText
                  .regular(
                    text: errorText,
                    textColor: Colors.red,
                    fontSize: MySize.getScaledSizeHeight(10),
                  )
                  .paddingOnly(
                    top: MySize.getScaledSizeHeight(5),
                    left: MySize.getScaledSizeWidth(2),
                  )
        ],
      );
    });
  }


  customPhoneField({
    text,
    controller,
    initialCountryCode,
    onChanged,
    onCountryChanged,
    textColor,
    readOnly,
    focusedBorder,
    border,
    hintText,
    requiredText,
    keyboardType,
    textInputAction,
    final isbordervisibal,
    final inputFormatters,
    String? errorText,
    Function()? onTap,
    bool showFlag = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text != null
            ? Row(
          children: [
            commonText.medium(
              text: text ?? "",
              fontSize: MySize.getScaledSizeHeight(14),
              textColor: textColor ?? color.textFieldTextColor,
            ),
            05.0.wSpace(),
            requiredText != null
                ? commonText.medium(
              text: requiredText,
              fontSize: MySize.getScaledSizeHeight(14),
              textColor: const Color(0xff838383),
            )
                : SizedBox()
          ],
        )
            : const SizedBox(),
        10.0.hSpace(),
        KeyboardVisibilityBuilder(
          builder: (p0, isKeyboardVisible) {
            return Container(
              height: MySize.getScaledSizeHeight(48),
              width: Get.width,
              padding: EdgeInsets.only(left: MySize.getScaledSizeWidth(16), right: MySize.getScaledSizeWidth(10)),
              decoration: BoxDecoration(
                color:  color.white,
                border: border ??
                    Border.all(
                      color: isbordervisibal && isKeyboardVisible
                          ? color.textFieldFocusColor
                          : errorText != ""
                          ? color.textFieldErrorColor
                          : color.onboardingBorderColor,
                      width: 1,
                    ),
                borderRadius: BorderRadius.circular(08),
              ),
              child: Align(
                alignment: Alignment.center,
                child: IntlPhoneField(
                  inputFormatters: inputFormatters,
                  pickerDialogStyle: PickerDialogStyle(
                    backgroundColor: color.white,
                    countryCodeStyle: TextStyle(
                      fontSize: MySize.getScaledSizeHeight(16),
                      color: Colors.black,
                      fontFamily: "Medium",
                      fontWeight: FontWeight.w500,
                    ),
                    countryNameStyle: TextStyle(
                      fontSize: MySize.getScaledSizeHeight(16),
                      color: Colors.black,
                      fontFamily: "Medium",
                      fontWeight: FontWeight.w500,
                    ),
                    searchFieldInputDecoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: color.onboardingTextColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: color.onboardingTextColor),
                      ),
                      errorBorder: InputBorder.none,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: color.onboardingTextColor),
                      ),
                      focusedErrorBorder: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: 'Search',
                      labelStyle: TextStyle(
                        fontSize: MySize.getScaledSizeHeight(16),
                        color: color.black,
                        fontFamily: "Medium",
                        fontWeight: FontWeight.w500,
                      ),
                      hintStyle: TextStyle(
                        fontSize: MySize.getScaledSizeHeight(16),
                        color: Colors.black,
                        fontFamily: "Medium",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    searchFieldCursorColor: color.black,
                  ),
                  style: TextStyle(
                    fontSize: MySize.getScaledSizeHeight(14),
                    color: Colors.black,
                    fontFamily: "Medium",
                    fontWeight: FontWeight.w400,
                  ),
                  dropdownTextStyle: TextStyle(
                    fontSize: MySize.getScaledSizeHeight(16),
                    color: Colors.black,
                    fontFamily: "Medium",
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  textAlign: TextAlign.start,
                  controller: controller,
                  disableLengthCheck: true,
                  dropdownIconPosition: IconPosition.trailing,
                  cursorColor: Colors.black,
                  readOnly: readOnly ?? false,
                  dropdownIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xff7D7D7D),
                  ),
                  showCountryFlag: showFlag,
                  // Dynamically control flag visibility
                  showDropdownIcon: showFlag,
                  // Hide dropdown if flag is hidden
                  onTap: onTap != null ? () => onTap() : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: MySize.getScaledSizeHeight(15)),
                    fillColor: color.white,
                    focusColor: Colors.transparent,
                    hintText: hintText??"Phone Number",
                    hintStyle: TextStyle(
                      fontSize: MySize.getScaledSizeHeight(14),
                      color: color.onboardingTextColor,
                      fontFamily: "Regular",
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  initialCountryCode: initialCountryCode,
                  onChanged: onChanged,
                  onCountryChanged: onCountryChanged,
                ),
              ),
            );
          },
        ),
        errorText == null
            ? const SizedBox(height: 0)
            : commonText.medium(
          text: errorText,
          fontSize: MySize.getScaledSizeHeight(10),
          textColor: color.textFieldErrorColor,
        )
            .paddingOnly(top: MySize.getScaledSizeHeight(2)),
      ],
    );
  }

  String formatDateByCountry(DateTime date, String countryCode) {
    Map<String, String> countryDateFormatMap = {
      'US': 'MM/dd/yyyy',
      'GB': 'dd/MM/yyyy',
      'IN': 'dd/MM/yyyy',
      'JP': 'yyyy/MM/dd',
      'DE': 'dd.MM.yyyy',
      'FR': 'dd/MM/yyyy',
      'CN': 'yyyy/MM/dd',
      'BR': 'dd/MM/yyyy',
      'RU': 'dd.MM.yyyy',
      'CA': 'yyyy-MM-dd',
      'AU': 'dd/MM/yyyy',
      'KR': 'yyyy.MM.dd',
      'IT': 'dd/MM/yyyy',
      'ES': 'dd/MM/yyyy',
      'SE': 'yyyy-MM-dd',
      'ZA': 'yyyy/MM/dd',
      'AE': 'dd/MM/yyyy',
      'MX': 'dd/MM/yyyy',
      'SA': 'dd/MM/yyyy',
      'NZ': 'dd/MM/yyyy',
      'SG': 'dd/MM/yyyy',
      'NL': 'dd-MM-yyyy',
      'BE': 'dd/MM/yyyy',
      'NO': 'dd.MM.yyyy',
      'DK': 'dd-MM-yyyy',
      'FI': 'dd.MM.yyyy',
      'CH': 'dd.MM.yyyy',
      'GR': 'dd/MM/yyyy',
      'PT': 'dd/MM/yyyy',
      'PL': 'yyyy-MM-dd',
      'TR': 'dd.MM.yyyy',
      'AR': 'dd/MM/yyyy',
      'CL': 'dd-MM-yyyy',
      'CO': 'dd/MM/yyyy',
      'PE': 'dd/MM/yyyy',
      'EG': 'dd/MM/yyyy',
      'TH': 'dd/MM/yyyy',
      'MY': 'dd/MM/yyyy',
      'ID': 'dd/MM/yyyy',
      'VN': 'dd/MM/yyyy',
      'PK': 'dd/MM/yyyy',
      'BD': 'dd/MM/yyyy',
    };

    String format = countryDateFormatMap[countryCode.toUpperCase()] ?? 'yyyy-MM-dd';
    return DateFormat(format).format(date);
  }

}
