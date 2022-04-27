// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'signin_screen.dart';
import 'signup_screen.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/strings.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';

import '../../models/auth/login_reposnse_model.dart';
import '../../models/common/user.dart';

import '../../service/api_service.dart';

import '../../widgets/common/common_button.dart';

class AuthOptionsScreen extends StatefulWidget {
  const AuthOptionsScreen({Key? key}) : super(key: key);

  @override
  State<AuthOptionsScreen> createState() => _AuthOptionsScreenState();
}

class _AuthOptionsScreenState extends State<AuthOptionsScreen> {
  GoogleSignInAccount? _currentUser;
  bool isRegisteredTapped = false;

  bool isLoginTapped = false;
  bool isRegTapped = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Image.asset(
                        "",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  (Platform.isIOS && Singleton.instance.osVersion > 13.0)
                      ? Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              color: Colors.white,
                              child: TextButton(
                                onPressed: () async {
                                  final credential = await SignInWithApple
                                      .getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                  );
                                  if (kDebugMode) {
                                    print(credential);
                                  }
                                  Singleton.instance
                                      .isInternetConnected()
                                      .then((intenet) {
                                    if (intenet != null && intenet) {
                                      callLoginSocialAPI(
                                          credential.email ?? "",
                                          false,
                                          credential.userIdentifier ?? "");
                                    } else {
                                      Singleton.instance.showSnackBar(
                                          context, Constant.noInternet);
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "",
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      isRegisteredTapped
                                          ? Strings.signUpWithApple
                                          : Strings.signInWithApple,
                                      style: GlobalStyleAndDecoration
                                          .authButtonTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Flexible(
                    child: Container(
                      color: Colors.white,
                      child: TextButton(
                        // color: Colors.white,
                        onPressed: () async {
                          _currentUser =
                              await Singleton.instance.googleSignIn.signIn();
                          if (kDebugMode) {
                            print(_currentUser);
                          }

                          Singleton.instance
                              .isInternetConnected()
                              .then((intenet) {
                            if (intenet != null && intenet) {
                              callLoginSocialAPI(
                                  _currentUser!.email, true, _currentUser!.id);
                            } else {
                              Singleton.instance
                                  .showSnackBar(context, Constant.noInternet);
                            }
                          });
                          if (kDebugMode) {
                            print(_currentUser);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              isRegisteredTapped
                                  ? Strings.signUpWithGoogle
                                  : Strings.signInWithGoogle,
                              style:
                                  GlobalStyleAndDecoration.authButtonTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: CommonButton(
                      onPressed: () async {
                        if (isRegisteredTapped) {
                          isLoginTapped = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen(
                                      isLoginTapped: false,
                                    )),
                          );

                          if (isLoginTapped) {
                            isRegisteredTapped = !isRegisteredTapped;
                            setState(() {});
                          }
                        } else {
                          isRegTapped = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SigninScreen(
                                      isRegisterTapped: false,
                                    )),
                          );

                          if (isRegTapped) {
                            isRegisteredTapped = !isRegisteredTapped;
                            setState(() {});
                          }
                        }
                      },
                      title: isRegisteredTapped
                          ? Strings.signUpWithEmail.toUpperCase()
                          : Strings.signInWithEmail.toUpperCase(),
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
                            color: Colors.white,
                            width:
                                1.0, // This would be the width of the underline
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          isRegisteredTapped = !isRegisteredTapped;

                          setState(() {});
                        },
                        child: Text(
                          isRegisteredTapped
                              ? Strings.loginHere.toUpperCase()
                              : Strings.registerHere.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> callLoginSocialAPI(
      String email, bool isGoogle, String socialID) async {
    LoginReposnseModel loginResponseModel;

    late Map<String, String> body;

    if (email.isEmpty) {
      body = {
        ApiParamters.device_token: "12345678",
        ApiParamters.device_type_auth: Singleton.instance.deviceType(),
        ApiParamters.login_type: ApiParamters.login_type_social,
        ApiParamters.social_type: isGoogle
            ? ApiParamters.social_type_google
            : ApiParamters.social_type_apple,
        ApiParamters.social_id: socialID,
      };
    } else {
      body = {
        ApiParamters.email: email,
        ApiParamters.device_token: "12345678",
        ApiParamters.device_type_auth: Singleton.instance.deviceType(),
        ApiParamters.login_type: ApiParamters.login_type_social,
        ApiParamters.social_type: isGoogle
            ? ApiParamters.social_type_google
            : ApiParamters.social_type_apple,
        ApiParamters.social_id: socialID,
      };
    }

    if (kDebugMode) {
      print("SOCIAL LOGIN PARAM = $body");
    }

    Singleton.instance.showDefaultProgress();
    final url = Uri.http(
        ApiConstants.BaseUrl, ApiConstants.BaseUrlHost + ApiConstants.login);
    if (kDebugMode) {
      print("url$url");
    }

    ApiService.postCall(url, body, context).then((response) {
      Singleton.instance.hideProgress();

      final responseData = json.decode(response.body);
      try {
        if (response.statusCode == 200) {
          loginResponseModel =
              LoginReposnseModel.fromJson(json.decode(response.body));
          String userData = jsonEncode(
              UserModel.fromJson(json.decode(response.body)['payload']));

          UserModel userModel =
              UserModel.fromJson(json.decode(response.body)['payload']);
          Singleton.instance.objLoginUser = userModel;
          if (userData != null) {
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
    });
  }
}
