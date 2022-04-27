import 'dart:io';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';
import '../../helpers/api_constant.dart';
import '../../service/api_service.dart';
import '../../models/common/user.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../widgets/common/common_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController =
      TextEditingController(text: Singleton.instance.objLoginUser.name);
  final hometownController =
      TextEditingController(text: Singleton.instance.objLoginUser.hometown);

  final FocusNode nameNode = FocusNode();
  final FocusNode hometownNode = FocusNode();

  File? _image;
  String? imagepath;

  @override
  void initState() {
    _image = null;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    hometownController.dispose();

    nameNode.dispose();
    hometownNode.dispose();

    super.dispose();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardSeparatorColor: Colors.white,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: nameNode,
        ),
        KeyboardActionsItem(focusNode: hometownNode),
      ],
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  clearTextInputs() {
    nameController.clear();
    hometownController.clear();
  }

  void _submitNextRequest() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (nameController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter name.");
    } else if (hometownController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter hometown.");
    } else {
      if (_image != null) {
        imagepath = _image!.absolute.path;

        callUpdateProfileAPI(nameController.text.toString(),
            hometownController.text.toString(), imagepath!);
      } else {
        callUpdateProfileAPI(nameController.text.toString(),
            hometownController.text.toString(), "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    void pickedImage(ImageSource imageSource) {
      Singleton.instance.pickImage(imageSource).then(
            (value) => setState(
              () {
                if (value == null) {
                } else {
                  _image = value;
                  setState(() {});
                }
              },
            ),
          );
    }

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: Singleton.instance.CommonAppbar(
          appbarText: "",
          leadingClickEvent: () {
            Navigator.of(context).pop();
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
                          Strings.editProfile.trim().toUpperCase(),
                          ColorCodes.navbar),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        child: Stack(
                          children: [
                            SizedBox(
                              // color: Colors.green,
                              height: 160,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: SizedBox(
                                        width: 160,
                                        height: 160,
                                        child: Stack(
                                          children: [
                                            (_image == null)
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                    child: Singleton
                                                            .instance
                                                            .objLoginUser
                                                            .profileImage
                                                            .isEmpty
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                            child: const Image(
                                                              width: 160,
                                                              height: 160,
                                                              image: AssetImage(
                                                                  ""),
                                                              fit: BoxFit.cover,
                                                            ))
                                                        : CachedNetworkImage(
                                                            memCacheHeight:
                                                                null,
                                                            memCacheWidth: 300,
                                                            imageUrl: Singleton
                                                                .instance
                                                                .objLoginUser
                                                                .profileImage,
                                                            height: 160,
                                                            width: 160,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context,
                                                                    url) =>
                                                                Singleton
                                                                    .instance
                                                                    .placeholderWidget(
                                                                        160,
                                                                        160),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Singleton
                                                                    .instance
                                                                    .placeholderWidget(
                                                                        160,
                                                                        160),
                                                          ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                    child: Image.file(
                                                      _image!,
                                                      fit: BoxFit.cover,
                                                      height: 160,
                                                      width: 160,
                                                    ),
                                                  ),
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  width: Singleton
                                                          .instance
                                                          .objLoginUser
                                                          .profileImage
                                                          .isEmpty
                                                      ? 0
                                                      : 0,
                                                  color: Singleton
                                                          .instance
                                                          .objLoginUser
                                                          .profileImage
                                                          .isEmpty
                                                      ? Colors.transparent
                                                      : Colors.transparent,
                                                ),
                                                // color: Colors.yellow,
                                              ),
                                              height: 160,
                                              width: 160,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: GestureDetector(
                                          onTap: () {
                                            Singleton.instance.showPicker(
                                                context, pickedImage);
                                          },
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ColorCodes.cameraBgColor,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.asset("",
                                                    height: 18, width: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                        .addTextFieldTopLabelWidget(
                                            Strings.nameLabel.toUpperCase()),
                                    Singleton.instance.addTextField(
                                        nameNode,
                                        nameController,
                                        TextInputType.text,
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
                                      Strings.hometownLabel.toUpperCase()),
                                  Singleton.instance.addTextField(
                                      hometownNode,
                                      hometownController,
                                      TextInputType.text,
                                      false),
                                  Container(
                                    color: Colors.black,
                                    height: 1,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Container(
                                //height: 50,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                width: double.infinity,
                                color: ColorCodes.navbar,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Strings.k9Information.toUpperCase(),
                                      style: Singleton.instance.setTextStyle(
                                        textColor: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        /*
                                        if (_image == null &&
                                            Singleton.instance.objLoginUser
                                                .profileImage.isEmpty) {
                                          Singleton.instance
                                              .showAlertDialogWithOkAction(
                                                  context,
                                                  Constant.alert,
                                                  "Please select photo.");
                                        } else 
                                        */
                                        if (nameController.text
                                            .trim()
                                            .isEmpty) {
                                          Singleton.instance
                                              .showAlertDialogWithOkAction(
                                                  context,
                                                  Constant.alert,
                                                  "Please enter name.");
                                        } else if (hometownController.text
                                            .trim()
                                            .isEmpty) {
                                          Singleton.instance
                                              .showAlertDialogWithOkAction(
                                                  context,
                                                  Constant.alert,
                                                  "Please enter hometown.");
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            Strings.add.toUpperCase(),
                                            style:
                                                Singleton.instance.setTextStyle(
                                              fontSize: TextSize.text_15,
                                              textColor: ColorCodes.yellow,
                                              fontWeight: FontWeight.bold,
                                              textDecoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          Container(
                                            color: ColorCodes.navbar,
                                            width: 10,
                                            height: 10,
                                          ),
                                          Image.asset(
                                            "",
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: CommonButton(
                                        onPressed: _submitNextRequest,
                                        title: Strings.next.toUpperCase(),
                                        textColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
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

  Future<void> callUpdateProfileAPI(
      String name, String hometown, String imagepath) async {
    Singleton.instance.showDefaultProgress();
    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.get_started);

    if (_image == null) {
      late Map<String, String> header;
      header = {
        HttpHeaders.authorizationHeader:
            "Bearer ${Singleton.instance.AuthToken}",
      };

      late Map<String, String> body;
      body = {
        ApiParamters.name: nameController.text,
        ApiParamters.hometown: hometownController.text,
        ApiParamters.device_type_auth: Singleton.instance.deviceType(),
      };
      Singleton.instance.showDefaultProgress();
      final url = Uri.http(ApiConstants.BaseUrl,
          ApiConstants.BaseUrlHost + ApiConstants.get_started);
      ApiService.postCallwithHeader(url, body, header, context)
          .then((response) {
        if (response.body.isNotEmpty) {
          final responseData = json.decode(response.body);
          try {
            Singleton.instance.hideProgress();
            if (response.statusCode == 200) {
              String userCommonData = jsonEncode(
                  UserModel.fromJson(json.decode(response.body)['payload']));
              UserModel userModel =
                  UserModel.fromJson(json.decode(response.body)['payload']);
              Singleton.instance.objLoginUser = userModel;
              Singleton.instance.setUserModel(userCommonData);

              Singleton.instance.AuthToken =
                  Singleton.instance.objLoginUser.token;
              Singleton.instance.showAlertDialogWithOkAction(
                  context, Constant.alert, responseData["message"]);
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
    } else {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        HttpHeaders.authorizationHeader:
            "Bearer ${Singleton.instance.AuthToken}",
      });
      request.fields[ApiParamters.name] = name;
      request.fields[ApiParamters.hometown] = hometown;
      request.fields[ApiParamters.device_type_auth] =
          Singleton.instance.deviceType();
      var multipartFile =
          await MultipartFile.fromPath(ApiParamters.profile_image, imagepath);
      request.files.add(multipartFile);
      var response = await request.send();

      try {
        var responsed = await http.Response.fromStream(response);
        final responseData = json.decode(responsed.body);
        Singleton.instance.hideProgress();
        if (response.statusCode == 200) {
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.appName, responseData["message"]);
        } else if (response.statusCode == 500) {
          Singleton.instance.showAInvalidTokenAlert(
              context, Constant.alert, responseData["message"]);
        } else if (response.statusCode == 501) {
          Singleton.instance.showAInvalidTokenAlertForLogout(
              context, Constant.alert, responseData["message"]);
          //  print(response.body);
        } else {
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.alert, responseData["message"]);
        }
      } catch (e) {
        Singleton.instance.hideProgress();
      }
    }
  }
}
