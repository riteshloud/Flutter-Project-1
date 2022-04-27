// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Tabbar/tabbar.dart';
import '../screens/Authentication/auth_options_screen.dart';
import '../helpers/singleton.dart';
import '../helpers/api_constant.dart';
import '../helpers/constant.dart';
import '../models/common/common_data_model.dart';
import '../models/common/dog_categories.dart';
import '../models/common/common_data_model.dart' as common;
import '../models/common/user.dart';
import '../service/api_service.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late Map<String, String> body;

  @override
  void initState() {
    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet != null && intenet) {
        callCommonDataAPI();
      } else {
        Singleton.instance.showAlertDialogWithOkAction(
            context, Constant.appName, Constant.noInternet);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(""), fit: BoxFit.cover),
      ),
    );
  }

  Future<void> callCommonDataAPI() async {
    CommonDataModel commondatamodel;

    Singleton.instance.showDefaultProgress();
    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.getCommonDetails);
    ApiService.getCall(url, context).then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            commondatamodel =
                CommonDataModel.fromJson(json.decode(response.body));
            var userData = commondatamodel.payload;
            String commondata = jsonEncode(
                Payload.fromJson(json.decode(response.body)['payload']));

            var decodedata = json.decode(response.body)['payload'];
            var paylpoad = common.Payload.fromJson(decodedata);

            var _categories = paylpoad.categories.cast<Categories>();
            Singleton.instance.arrCategories = _categories;

            if (userData != null) {
              Singleton.instance.setDataModel(Constant.commonData, commondata);
            }

            // ***************************************
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var status = prefs.getBool(Constant.isLoggedIn) ?? false;

            UserModel userModel;
            if (status == true) {
              Singleton.instance.getUserModel().then((value) {
                if (value != null) {
                  Map userMap = jsonDecode(value);
                  userModel = UserModel.fromJson(userMap);
                  if (userModel != null || userModel.id <= 0) {
                    Singleton.instance.objLoginUser = userModel;
                    Singleton.instance.AuthToken =
                        Singleton.instance.objLoginUser.token;

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => DynamicTabbedPage(
                            selectedIndex: 0,
                          ),
                        ),
                        (Route<dynamic> route) => false);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const AuthOptionsScreen()),
                        (Route<dynamic> route) => false);
                  }
                }
              });
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const AuthOptionsScreen()),
                  (Route<dynamic> route) => false);
            }
          } else if (response.statusCode == 500) {
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else if (response.statusCode == 501) {
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          } else {
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
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
}
