// ignore_for_file: non_constant_identifier_names, prefer_final_fields, unnecessary_null_comparison

import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image_picker/image_picker.dart';

import 'constant.dart';
import 'colors.dart';
import 'api_constant.dart';
import '../models/common/user.dart';
import '../screens/Authentication/auth_options_screen.dart';
import '../models/common/dog_categories.dart';
import '../models/course_detail_response_model.dart';
import '../models/common/user_profile_response.dart';
import '../service/api_service.dart';

class Singleton {
  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  static Singleton get instance => _instance;

  bool isDarkMode = false;
  double screenWidth = 0.0;
  double osVersion = 0.0;

  bool isSearchingCourse = false;
  String searchedCourseKeyword = "";

  bool isSearchingFavouriteCourse = false;
  String searchedFavouriteCourseKeyword = "";

  bool isSearchingCommunity = false;
  String searchedCommunityKeyword = "";

  bool isUserPlayVideo = false;
  bool isVideoCompleted = false;

  String token = "";
  String AuthToken = "";
  int? dogId;
  String userId = "";
  String userProfile = "";
  String k9Name = "";
  String reasonSpam = "";
  Categories objSelectedBreed = Categories(id: 0, name: "", description: "");

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  UserModel objLoginUser = UserModel.fromJson({});
  UserModel objSelectedBlogUser = UserModel.fromJson({});
  List<Categories> arrCategories = [];
  List<K9Info> arrUserK9 = [];
  List<LessionList> arrLessions = [];

//SVPROGRESS HUD
  void customizationSVProgressHUD() {
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom);
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light);
    SVProgressHUD.setBackgroundLayerColor(Colors.black54);
    SVProgressHUD.setBackgroundColor(
        (Platform.isIOS ? Colors.white : Colors.green));
    SVProgressHUD.setForegroundColor(Colors.black);
    SVProgressHUD.setRingRadius(18);
    SVProgressHUD.setRingThickness(2.5);
    SVProgressHUD.setCornerRadius(10);
  }

  void showDefaultProgress() {
    SVProgressHUD.show();
  }

  void showProgressWithTitle(String title) {
    SVProgressHUD.show(status: title);
  }

  void hideProgress() {
    SVProgressHUD.dismiss();
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setAuthToken() async {
    final SharedPreferences prefs = await _prefs;
    AuthToken = prefs.getString(Constant.authToken) ?? "";

    if (Singleton.instance.AuthToken.isEmpty) {
      Singleton.instance.AuthToken = AuthToken;
    }
  }

  static bool isValidatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static bool isValidEmail(String value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  Future<void> setUserModel(String user) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(Constant.user, user);
  }

  Future<String?> getUserModel() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(Constant.user);
  }

  Future<void> setDataModel(String key, String common_data) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, common_data);
  }

  Future<String?> getDataModel(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> setListData(String? key, List<String> commonList) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList(key!, commonList);
  }

  Future<List<dynamic>?> getListData(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(key);
  }

  Future<String> getMessage() async {
    final SharedPreferences prefs = await _prefs;
    token = prefs.getString(ApiParamters.device_token) ?? "";
    return token;
  }

  //TEXTFIELD DECORATION
  InputDecoration setTextFieldDecoration(String hintText) {
    return InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: ColorCodes.textFieldHintColor,
      ),
    );
  }

  //SEARCH TEXTFIELD DECORATION
  InputDecoration setSearchFieldDecoration(String hintText, String iconName) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Image.asset(
          iconName,
          fit: BoxFit.cover,
          height: 16,
          width: 16,
        ),
      ),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      hintText: "Search",
      hintStyle: const TextStyle(color: ColorCodes.textFieldHintColor),
      contentPadding: const EdgeInsets.only(top: 14),
    );
  }

  //TEXTSTYLE
  TextStyle setTextStyle({
    double fontSize = 15,
    Color textColor = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    String fontFamily = Constant.oxaniumFontFamily,
    double height = 1.25,
    TextDecoration textDecoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: textColor,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      height: height,
      decoration: textDecoration,
    );
  }

  Text addTextFieldTopLabelWidget(String title) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: Singleton.instance.setTextStyle(
        fontSize: TextSize.text_13,
        fontWeight: FontWeight.bold,
        textColor: ColorCodes.hintcolor,
      ),
    );
  }

  Text addPageTitle(String title, Color color) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: Singleton.instance.setTextStyle(
        fontSize: TextSize.text_24,
        fontFamily: Constant.robotoCondensedFontFamily,
        fontWeight: FontWeight.bold,
        textColor: color,
      ),
    );
  }

  PlatformTextField addTextField(
      FocusNode node,
      TextEditingController controller,
      TextInputType inputType,
      bool isPassword) {
    return PlatformTextField(
      scrollPadding: Constant.textFieldInset,
      focusNode: node,
      controller: controller,
      cursorColor: Colors.black,
      autocorrect: false,
      keyboardType: inputType,
      obscureText: isPassword,
      material: (_, __) => MaterialTextFieldData(
        decoration: Singleton.instance.setTextFieldDecoration(""),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
      style: Singleton.instance.setTextStyle(
        fontFamily: Constant.robotoFontFamily,
        fontWeight: FontWeight.normal,
        textColor: ColorCodes.textColorGray,
      ),
    );
  }

  PlatformTextField multilineTextField(
    FocusNode node,
    TextEditingController controller,
    TextInputType inputType,
    bool isPassword,
  ) {
    return PlatformTextField(
      scrollPadding: Constant.textFieldInset,
      focusNode: node,
      controller: controller,
      cursorColor: Colors.black,
      autocorrect: false,
      keyboardType: inputType,
      obscureText: isPassword,
      maxLines: 10,
      minLines: 1,
      material: (_, __) => MaterialTextFieldData(
        decoration: Singleton.instance.setTextFieldDecoration(""),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
      style: Singleton.instance.setTextStyle(
        fontFamily: Constant.robotoFontFamily,
        fontWeight: FontWeight.normal,
        textColor: ColorCodes.navbar,
      ),
    );
  }

  Future<File?> pickImage(ImageSource pickImage) async {
    var imagePicker = ImagePicker();

    try {
      final pickedFile = await imagePicker.pickImage(
        source: pickImage,
        imageQuality: 40,
        // imageQuality: 60,
      );

      return File(pickedFile!.path);
    } catch (e) {
      return File("");
    }
  }

  void showPicker(context, Function pickedImage) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // color: Colors.pink,
                child: Wrap(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pickedImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.photo_library,
                                color: ColorCodes.navbar),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Choose image",
                              style: setTextStyle(
                                  fontWeight: FontWeight.bold,
                                  textColor: ColorCodes.navbar),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pickedImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.photo_camera,
                                color: ColorCodes.navbar),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Take a photo",
                              style: setTextStyle(
                                  fontWeight: FontWeight.bold,
                                  textColor: ColorCodes.navbar),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.photo_camera,
                                color: Colors.transparent),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Cancel",
                              style: setTextStyle(
                                  fontWeight: FontWeight.bold,
                                  textColor: ColorCodes.navbar),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  //MODAL BOTTOM SHEET
  void showBottomSheetWTFraction(
      BuildContext context, Widget childWidget, double fraction) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext bc) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * fraction,
            child: childWidget,
          ),
        );
      },
    );
  }

  void showBottomSheet(BuildContext context, Widget childWidget) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      // material: MaterialModalSheetData(
      //   useRootNavigator: true,
      //   isScrollControlled: true,
      // ),
      // cupertino: CupertinoModalSheetData(
      //   useRootNavigator: true,
      //   barrierDismissible: false,
      // ),
      context: context,
      builder: (BuildContext bc) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: childWidget,
            )
          ]),
        );
      },
    ).then((value) {});
  }

  //DATEPICKER
  Future<DateTime?> presentDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );

    return pickedDate;
  }

  Future<bool> isIOS() async {
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  String deviceType() {
    String device_type;
    if (Platform.isIOS) {
      device_type = ApiParamters.ios;
    } else {
      device_type = ApiParamters.android;
    }

    return device_type;
  }

  Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<bool?> showAlertDialogWithOptions(BuildContext context, String title,
      String message, String positiveOption, String negativeOption) async {
    return await showPlatformDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: PlatformAlertDialog(
            title: Text(
              title,
              style: Constant.alertTitleStyle,
            ),
            content: Text(
              message,
              style: Constant.alertBodyStyle,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  negativeOption,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  positiveOption,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //SNACK DIALOG
  Future<void> showSnackBar(BuildContext context, String message) async {
    SnackBar snackbar = SnackBar(
      duration: const Duration(milliseconds: 1000),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: Singleton.instance.setTextStyle(textColor: Colors.white),
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<bool?> showAlertDialogWithSingleCallbackOption(
      BuildContext context,
      String title,
      String message,
      String positiveOption,
      Function positivebutton) async {
    return await showPlatformDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: PlatformAlertDialog(
            title: Text(
              title,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16, fontWeight: FontWeight.bold),
            ),
            content: Text(
              message,
              style:
                  Singleton.instance.setTextStyle(fontSize: TextSize.text_16),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Ok",
                  style: Singleton.instance
                      .setTextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  positivebutton();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //ALERT DIALOG
  Future<void> showAlertDialogWithOkAction(
      BuildContext context, String title, String content) async {
    showPlatformDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: ThemeData.light(),
          child: PlatformAlertDialog(
            title: Text(
              title,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16, fontWeight: FontWeight.bold),
            ),
            content: Text(
              content,
              style:
                  Singleton.instance.setTextStyle(fontSize: TextSize.text_16),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Ok",
                  style: Singleton.instance
                      .setTextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //ALERT DIALOG
  Future<void> showAInvalidTokenAlert(
      BuildContext context, String title, String content) async {
    showPlatformDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: ThemeData.light(),
          child: PlatformAlertDialog(
            title: Text(
              title,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16, fontWeight: FontWeight.bold),
            ),
            content: Text(
              content,
              style:
                  Singleton.instance.setTextStyle(fontSize: TextSize.text_16),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Ok",
                  style: Singleton.instance
                      .setTextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  //FORCEFULLY LOGOUT USER
                  Navigator.of(ctx).pop();
                  // logoutUser(context);
                  callLogoutAPI(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showAInvalidTokenAlertForLogout(
      BuildContext context, String title, String content) async {
    showPlatformDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: ThemeData.light(),
          child: PlatformAlertDialog(
            title: Text(
              title,
              style: Singleton.instance.setTextStyle(
                  fontSize: TextSize.text_16, fontWeight: FontWeight.bold),
            ),
            content: Text(
              content,
              style:
                  Singleton.instance.setTextStyle(fontSize: TextSize.text_16),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Ok",
                  style: Singleton.instance
                      .setTextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  //FORCEFULLY LOGOUT USER
                  //logoutUser(context);
                  callLogoutAPI(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar CommonAppbar(
      {String? appbarText,
      Function? leadingClickEvent,
      String? endText,
      Function? endTextClickEvent,
      Color? backgroundColor,
      Color? iconColor,
      Color? appbarTextColor,
      Color? endTextColor}) {
    return AppBar(
      backgroundColor: backgroundColor ?? ColorCodes.navbar,
      elevation: 0,
      leading: null,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: PlatformIconButton(
              padding: const EdgeInsets.only(right: 30),
              onPressed: () => leadingClickEvent!(),
              icon: Image.asset(
                "",
                width: 26,
                height: 26,
                color: iconColor ?? Colors.white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              appbarText!,
              textAlign: TextAlign.center,
              style: Singleton.instance.setTextStyle(
                  fontFamily: Constant.robotoCondensedFontFamily,
                  fontWeight: FontWeight.bold,
                  textColor: appbarTextColor ?? Colors.white,
                  fontSize: TextSize.text_20),
            ),
          ),
          Visibility(
            //visible: (endText?.isEmpty ?? "".isEmpty) ? false : true,
            child: (endText?.isEmpty ?? "".isEmpty)
                ? Container(
                    alignment: Alignment.centerLeft,
                    child: PlatformIconButton(
                      onPressed: null,
                      icon: Image.asset(
                        "",
                        width: 26,
                        height: 26,
                        color: Colors.transparent,
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => (endText?.isEmpty ?? "".isEmpty)
                          ? null
                          : endTextClickEvent!(),
                      child: Text(
                        endText!,
                        textAlign: TextAlign.center,
                        style: Singleton.instance.setTextStyle(
                          fontFamily: Constant.robotoCondensedFontFamily,
                          fontWeight: FontWeight.w700,
                          textColor: endTextColor ?? Colors.white,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget divider() {
    return const Divider(
      height: 1,
      color: ColorCodes.dividerShade,
    );
  }

  Future<void> callLogoutAPI(BuildContext context) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Map<String, String> body;
    body = {
      ApiParamters.device_type_auth: Singleton.instance.deviceType(),
      ApiParamters.device_token: "12345678",
    };

    final url = Uri.http(
        ApiConstants.BaseUrl, ApiConstants.BaseUrlHost + ApiConstants.logout);

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200 ||
              response.statusCode == 500 ||
              response.statusCode == 501) {
            if (Singleton.instance.objLoginUser.regType == "social") {
              Singleton.instance.googleSignIn.disconnect();
            }

            Singleton.instance.objLoginUser = UserModel.fromJson({});
            Singleton.instance.objSelectedBlogUser = UserModel.fromJson({});
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Singleton.instance.userProfile = "";
            // Singleton.instance.breedSelectedValue = "";
            Singleton.instance.k9Name = "";
            Singleton.instance.objSelectedBreed =
                Categories(id: 0, name: "", description: "");

            prefs.clear();
            const page = AuthOptionsScreen();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => page),
                (Route<dynamic> route) => false);
          }
        } on SocketException {
          Singleton.instance.hideProgress();
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          Singleton.instance.hideProgress();
        }
      } else {
        //Singleton.instance.hideProgress();
        if (kDebugMode) {
          if (kDebugMode) {
            print("EMPTY RESPONSE");
          }
        }
      }
    });
  }

  Widget placeholderWidget(double height, double width) {
    return Image.asset(
      "",
      height: height,
      width: width,
      fit: BoxFit.fitHeight,
    );
  }

  Widget widePlaceholderWidget(double height, double width) {
    return Image.asset(
      "",
      height: height,
      width: width,
      fit: BoxFit.fitHeight,
    );
  }

  Widget widePlaceholderWithGreyColorWidget(double height, double width) {
    return Image.asset(
      "",
      height: height,
      width: width,
      fit: BoxFit.fitHeight,
    );
  }
}
