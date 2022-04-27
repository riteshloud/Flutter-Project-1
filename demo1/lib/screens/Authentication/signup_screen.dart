// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../helpers/api_constant.dart';
import '../../helpers/constant.dart';
import '../../helpers/strings.dart';
import '../../helpers/colors.dart';
import '../../helpers/singleton.dart';
import '../../models/auth/login_reposnse_model.dart';
import '../../models/common/user.dart';
import '../../service/api_service.dart';
import '../../widgets/common/common_button.dart';
import '../../models/common/common_data_model.dart' as common;
import '../../models/common/dog_categories.dart';

class SignupScreen extends StatefulWidget {
  bool isLoginTapped = false;
  SignupScreen({Key? key, required this.isLoginTapped}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  List<Categories> _categories = [];

  @override
  void initState() {
    Singleton.instance.getDataModel(Constant.commonData).then((value) {
      if (value != null) {
        setState(() {
          var decodedata = json.decode(value);
          var paylpoad = common.Payload.fromJson(decodedata);
          _categories.clear();
          _categories = paylpoad.categories.cast<Categories>();
          Singleton.instance.arrCategories = _categories;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();

    super.dispose();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardSeparatorColor: Colors.white,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: emailNode,
        ),
        KeyboardActionsItem(
          focusNode: passwordNode,
        ),
        KeyboardActionsItem(
          focusNode: confirmPasswordNode,
        ),
      ],
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  clearTextInputs() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void _submitSignupRequest() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    if (emailController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter email.");
    } else if (!Singleton.isValidEmail(emailController.text.trim())) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter valid email.");
    } else if (passwordController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter password.");
    } else if (confirmPasswordController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter confirm password.");
    } else if (passwordController.text != confirmPasswordController.text) {
      Singleton.instance.showAlertDialogWithOkAction(context, Constant.alert,
          "Password and confirm password doesn't match.");
    } else {
      Singleton.instance.isInternetConnected().then((intenet) {
        if (intenet != null && intenet) {
          callSignupAPI(emailController.text.trim().toString(),
              passwordController.text.trim().toString());
        } else {
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.appName, Constant.noInternet);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: Singleton.instance.CommonAppbar(
          appbarText: "",
          leadingClickEvent: () {
            Navigator.pop(context, false);
          },
          backgroundColor: Colors.white,
          iconColor: Colors.black,
          endText: "",
          endTextClickEvent: () {},
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Singleton.instance.addPageTitle(
                          Strings.signUp.toUpperCase(), ColorCodes.navbar),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: KeyboardActions(
                          config: _buildConfig(context),
                          disableScroll: true,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Singleton.instance
                                        .addTextFieldTopLabelWidget(Strings
                                            .emailAddressLabel
                                            .toUpperCase()),
                                    Singleton.instance.addTextField(
                                        emailNode,
                                        emailController,
                                        TextInputType.emailAddress,
                                        false),
                                    Container(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Singleton.instance.addTextFieldTopLabelWidget(
                                      Strings.passwordLabel.toUpperCase()),
                                  Singleton.instance.addTextField(
                                      passwordNode,
                                      passwordController,
                                      TextInputType.visiblePassword,
                                      true),
                                  Container(
                                    color: Colors.black,
                                    height: 1,
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Singleton.instance
                                        .addTextFieldTopLabelWidget(Strings
                                            .confirmPasswordLabel
                                            .toUpperCase()),
                                    Singleton.instance.addTextField(
                                        confirmPasswordNode,
                                        confirmPasswordController,
                                        TextInputType.visiblePassword,
                                        true),
                                    Container(
                                      color: Colors.black,
                                      height: 1,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: CommonButton(
                                        onPressed: _submitSignupRequest,
                                        title: Strings.signUp.toUpperCase(),
                                        textColor: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          bottom:
                                              1, // This can be the space you need betweeb text and underline
                                        ),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: ColorCodes.titleBar,
                                          width:
                                              1.0, // This would be the width of the underline
                                        ))),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: Text(
                                            Strings.loginHere.toUpperCase(),
                                            style: const TextStyle(
                                              color: ColorCodes.titleBar,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> callSignupAPI(String email, String password) async {
    LoginReposnseModel loginResponseModel;

    late Map<String, String> body;
    body = {
      ApiParamters.email: email,
      ApiParamters.password: password,
      ApiParamters.device_token: "12345678",
      ApiParamters.device_type_auth: Singleton.instance.deviceType(),
      ApiParamters.login_type: ApiParamters.login_type_normal,
    };

    Singleton.instance.showDefaultProgress();
    final url = Uri.http(
        ApiConstants.BaseUrl, ApiConstants.BaseUrlHost + ApiConstants.register);

    Singleton.instance.showDefaultProgress();
    ApiService.postCall(url, body, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            loginResponseModel =
                LoginReposnseModel.fromJson(json.decode(response.body));

            String userData = jsonEncode(
                UserModel.fromJson(json.decode(response.body)['payload']));
            if (userData != null) {
              Singleton.instance.setUserModel(userData);

              UserModel userModel =
                  UserModel.fromJson(json.decode(response.body)['payload']);
              Singleton.instance.objLoginUser = userModel;
              Singleton.instance.setUserModel(userData);

              Singleton.instance.AuthToken = loginResponseModel.payload.token;
            }
          } else if (response.statusCode == 500) {
            Singleton.instance.showAInvalidTokenAlert(
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
