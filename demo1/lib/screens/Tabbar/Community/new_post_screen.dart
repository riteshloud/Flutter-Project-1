import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../helpers/colors.dart';
import '../../../helpers/constant.dart';
import '../../../helpers/singleton.dart';
import '../../../helpers/strings.dart';
import '../../../helpers/api_constant.dart';

import '../../../service/api_service.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final FocusNode titleNode = FocusNode();
  final FocusNode descriptionNode = FocusNode();
  File? _image;

  @override
  void initState() {
    _image = null;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    titleNode.dispose();
    descriptionNode.dispose();

    super.dispose();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardSeparatorColor: Colors.white,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: titleNode,
        ),
        KeyboardActionsItem(
          focusNode: descriptionNode,
        ),
      ],
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  clearTextInputs() {
    titleController.clear();
    descriptionController.clear();
  }

  void _submitLoginRequest() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    if (descriptionController.text.trim().isEmpty) {
      Singleton.instance.showAlertDialogWithOkAction(
          context, Constant.alert, "Please enter description.");
    } else {
      if (_image == null) {
        callMakeAPostWithoutImage(descriptionController.text, "");
      } else {
        callMakeAPost(descriptionController.text, "", _image!.path.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var pictureWidth = MediaQuery.of(context).size.width * 0.35;

    void pickedImage(ImageSource imageSource) {
      Singleton.instance.pickImage(imageSource).then((value) => setState(() {
            if (value != null) {
              _image = value;
              setState(() {});
            }
          }));
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
            endTextClickEvent: () {}),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /* Padding(
                padding: const EdgeInsets.only(left: 10, top: 50),
                child: GestureDetector(
                  child: Image.asset(
                    AssetIcons.backBlack,
                    height: 36,
                    width: 36,
                  ),
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),*/
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Singleton.instance
                        .addPageTitle(Strings.newpost, ColorCodes.navbar),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Singleton.instance.addTextFieldTopLabelWidget(
                                    Strings.description),
                                Singleton.instance.multilineTextField(
                                    descriptionNode,
                                    descriptionController,
                                    TextInputType.multiline,
                                    false),
                                Container(
                                  color: Colors.black,
                                  height: 1,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                Singleton.instance
                                    .showPicker(context, pickedImage);
                              },
                              child: Container(
                                width: double.maxFinite,
                                height: MediaQuery.of(context).size.height / 5,
                                child: Stack(
                                  children: [
                                    if (_image == null)
                                      Center(
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "",
                                              height: pictureWidth * 0.2,
                                              width: pictureWidth * 0.2,
                                              color: ColorCodes.hintcolor,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              Strings.addImage,
                                              style: Singleton.instance
                                                  .setTextStyle(
                                                      textColor:
                                                          ColorCodes.hintcolor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                            ),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                        ),
                                      ),
                                    if (_image != null)
                                      Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                        width: double.maxFinite,
                                      ),
                                    if (_image != null)
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: ColorCodes.hintcolor,
                                            )),
                                      ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: ColorCodes.hintcolor),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: Constant.gradientDecoration,
                                        // color: Colors.white,
                                        child: TextButton(
                                          onPressed: _submitLoginRequest,
                                          child: const Text(
                                            'ADD POST',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  Constant.oxaniumFontFamily,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {},
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

  callMakeAPost(String description, String title, String imagepath) async {
    Singleton.instance.showDefaultProgress();

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.createPost);

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    });
    request.fields[ApiParamters.title] = title;
    request.fields[ApiParamters.description] = description;

    var multipartFile =
        await MultipartFile.fromPath(ApiParamters.image, imagepath);
    request.files.add(multipartFile);
    var response = await request.send();

    try {
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      Singleton.instance.hideProgress();

      if (response.statusCode == 200) {
        Singleton.instance.showSnackBar(context, "Successfully created!");

        Navigator.of(context).pop();
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
    } catch (e) {
      if (kDebugMode) {
        print("Exception $e");
      }
    }
  }

  callMakeAPostWithoutImage(String description, String title) async {
    Singleton.instance.showDefaultProgress();

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.createPost);

    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    late Map<String, String> body;
    body = {
      ApiParamters.title: title,
      ApiParamters.description: description,
    };

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            Singleton.instance.showSnackBar(context, "Successfully created!");

            Navigator.of(context).pop();
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
