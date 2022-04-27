// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'forgot_password_screen.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/api_constant.dart';
import '../../helpers/strings.dart';
import '../../models/auth/login_reposnse_model.dart';
import '../../service/api_service.dart';
import '../../models/common/user.dart';
import '../../widgets/common/common_button.dart';

class SigninScreen extends StatefulWidget {
  bool isRegisterTapped = false;

  SigninScreen({Key? key, required this.isRegisterTapped}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    emailNode.dispose();
    passwordNode.dispose();

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
      ],
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  clearTextInputs() {
    emailController.clear();
    passwordController.clear();
  }

  void _submitLoginRequest() {
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
    } else {
      Singleton.instance.isInternetConnected().then((intenet) {
        if (intenet != null && intenet) {
          callLoginAPI(emailController.text.trim().toString(),
              passwordController.text.toString());
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
            endTextClickEvent: () {}),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                        Strings.signIn.toUpperCase(), ColorCodes.navbar),
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Singleton.instance.addTextFieldTopLabelWidget(
                                      Strings.emailAddressLabel.toUpperCase()),
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
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen()),
                                  );
                                },
                                child: Text(
                                  Strings.forgotPassword.toUpperCase(),
                                  style: Singleton.instance.setTextStyle(
                                    fontSize: TextSize.text_12,
                                    textColor: ColorCodes.titleBar,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: CommonButton(
                                      onPressed: _submitLoginRequest,
                                      title: Strings.signIn.toUpperCase(),
                                      backgroundColor: ColorCodes.red,
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
                                          Strings.registerHere.toUpperCase(),
                                          style: const TextStyle(
                                            color: ColorCodes.titleBar,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
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
    );
  }

  // ******** API CALL ********
  Future<void> callLoginAPI(String email, String password) async {
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
        ApiConstants.BaseUrl, ApiConstants.BaseUrlHost + ApiConstants.login);

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
              UserModel userModel =
                  UserModel.fromJson(json.decode(response.body)['payload']);
              Singleton.instance.objLoginUser = userModel;
              Singleton.instance.setUserModel(userData);

              Singleton.instance.dogId = Singleton.instance.objLoginUser.dogId;
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
          response.success = responseData['success'];
          response.message = responseData['message'];
          response.code = responseData['code'];
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
