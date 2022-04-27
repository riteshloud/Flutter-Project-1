import 'package:flutter/material.dart';
import '../helpers/colors.dart';

class Constant {
  static const String oxaniumFontFamily = "Oxanium";
  static const String robotoFontFamily = "Roboto";
  static const String robotoCondensedFontFamily = "RobotoCondensed";

  static SizedBox sideMenuWidthBox = const SizedBox(width: 16.0);
  static SizedBox sideMenuHeightBox = const SizedBox(height: 8.0);

  static String privacyURL = "http://privacy-policy";
  static String termsURL = "http://terms-of-service";

  static String appName = "Demo1";

  static String pleaseWait = "please Wait";
  static String fetchingData = "fetching Data";
  static String isLoggedIn = "isLoggedIn";
  static String isfirstRun = "isfirstRun";
  static String authToken = "AuthToken";
  static String userId = "userId";
  static String user = "user";
  static String commonData = "common_data";
  // static String get_profile = "get_profile";
  static String existingK9Data = "existingK9Data";

  static String alert = "Alert";
  static String noInternet =
      "Please check your internet connection and try again.";
  static String failureError =
      "Sorry we are unable to connect with the server, please try again later";

  static TextStyle alertTitleStyle = const TextStyle(
      fontSize: TextSize.text_18,
      fontWeight: FontWeight.bold,
      color: Colors.black);
  static TextStyle alertBodyStyle = const TextStyle(
      fontSize: TextSize.text_16,
      fontWeight: FontWeight.normal,
      color: Colors.black);

  static EdgeInsets textFieldInset = const EdgeInsets.symmetric(vertical: 60);

  static BoxDecoration gradientDecoration = const BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xFF1C66E0), ColorCodes.titleBar],
          begin: FractionalOffset(0.25, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp));
}

class SubscriptionPackage {
  static const monthlyPackage = "com.demo.monthly";
}
//**** GLOBAL STYLE AND DECORATION ****

class GlobalStyleAndDecoration {
  static TextStyle authButtonTextStyle = const TextStyle(
    fontSize: TextSize.text_15,
    fontWeight: FontWeight.bold,
    // color: AppColors.primary,
    fontFamily: Constant.robotoFontFamily,
    color: Color(0xff696969),
  );

  static BoxDecoration commenttextFieldBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: ColorCodes.unselectedColor,
  );

  static SizedBox spaceBetweenLabelText = const SizedBox(
    height: 6,
  );

  static BoxDecoration textFieldBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
  );

  static BoxShadow boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3), // changes position of shadow
  );

  static BoxDecoration bottomShadowDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    ),
  );

  static BoxDecoration shadowDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
    borderRadius: BorderRadius.circular(12),
  );

  //TEXT STYLE
  static TextStyle navigationTitleStyle = const TextStyle(
    fontSize: TextSize.text_18,
    fontWeight: FontWeight.w700,
    color: ColorCodes.primary,
    fontFamily: Constant.robotoCondensedFontFamily,
  );

  static InputDecoration textFieldDecoration = const InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      hintText: "Enter full name");
}

class Size {
  static const SizedBox buttonBox = SizedBox(height: 10);
  static const EdgeInsets buttonPadding =
      EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0);
}

class TextSize {
  static const double text_10 = 10;
  static const double text_11 = 11;
  static const double text_12 = 12;
  static const double text_13 = 13;
  static const double text_14 = 14;
  static const double text_15 = 15;
  static const double text_16 = 16;
  static const double text_17 = 17;
  static const double text_18 = 18;
  static const double text_19 = 19;
  static const double text_20 = 20;
  static const double text_21 = 21;
  static const double text_22 = 22;
  static const double text_23 = 23;
  static const double text_24 = 24;
  static const double text_25 = 25;
  static const double text_26 = 26;
  static const double text_27 = 27;
  static const double text_28 = 28;
  static const double text_29 = 29;
  static const double text_30 = 30;
}
