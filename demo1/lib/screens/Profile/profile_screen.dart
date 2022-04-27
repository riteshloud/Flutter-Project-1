// ignore_for_file: must_be_immutable, unused_field, unnecessary_null_comparison

import 'dart:io';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'edit_profile_screen.dart';
import 'favourite_videos_screen.dart';
import '../../screens/Tabbar/Community/community_screen.dart';

import '../../helpers/colors.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';
import '../../helpers/strings.dart';
import '../../helpers/api_constant.dart';

import '../../models/common/user.dart';
import '../../models/common/user_profile_response.dart';
import '../../models/common/dog_categories.dart';
import '../../models/auth/login_reposnse_model.dart';

import '../../service/api_service.dart';

import '../../widgets/common/safearea_widget.dart';

class ProfileScreen extends StatefulWidget {
  bool isViewProfile = false;
  String userID = "";

  ProfileScreen({Key? key, required this.isViewProfile, required this.userID})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class K9Information {
  int id;
  String name;
  String breed;

  K9Information(this.id, this.name, this.breed);
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> arrOptions = Singleton.instance.objLoginUser.regType == "social"
      ? ["Edit Profile", "Account Settings", "Favorited Videos", "Logout"]
      : [
          "Edit Profile",
          "Account Settings",
          "Change Password",
          "Favorited Videos",
          "Logout"
        ];

  File? _image;

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

  @override
  void initState() {
    if (widget.isViewProfile) {
      // OTHER PROFILE
      arrOptions.clear();
      callGetUserProfileAPI(context, widget.userID);
    } else {
      if (Singleton.instance.objLoginUser == null) {
      } else if (Singleton.instance.objLoginUser.id == null) {
      } else {
        callGetUserProfileAPI(
            context, Singleton.instance.objLoginUser.id.toString());
      }
    }

    super.initState();
  }

  Widget demoProfile() {
    return Image.asset(
      "",
      fit: BoxFit.cover,
      height: 160,
      width: 160,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: ColoredSafeArea(
        color: ColorCodes.navbar,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            //physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 220,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  color: ColorCodes.navbar,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 159,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 159,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 63,
                                                color: ColorCodes.navbar,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 96,
                                                color: ColorCodes.navbar,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 16,
                                          top: 20,
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Image.asset(
                                                "",
                                                width: 26,
                                                height: 26,
                                                color: Colors.white,
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
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: !widget.isViewProfile
                                            ? Singleton.instance.objLoginUser
                                                    .profileImage.isEmpty
                                                ? Image.asset(
                                                    "",
                                                    fit: BoxFit.cover,
                                                    height: 160,
                                                    width: 160,
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                    child: (Singleton
                                                            .instance
                                                            .objLoginUser
                                                            .profileImage
                                                            .isEmpty)
                                                        ? Singleton.instance
                                                            .placeholderWidget(
                                                                160, 160)
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
                                            : Singleton
                                                    .instance
                                                    .objSelectedBlogUser
                                                    .profileImage
                                                    .isEmpty
                                                ? Image.asset(
                                                    "",
                                                    fit: BoxFit.cover,
                                                    height: 160,
                                                    width: 160,
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.0),
                                                    child: CachedNetworkImage(
                                                      memCacheHeight: null,
                                                      memCacheWidth: 300,
                                                      imageUrl: Singleton
                                                          .instance
                                                          .objSelectedBlogUser
                                                          .profileImage,
                                                      height: 160,
                                                      width: 160,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          Singleton.instance
                                                              .placeholderWidget(
                                                                  160, 160),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Singleton.instance
                                                              .placeholderWidget(
                                                                  160, 160),
                                                    ),
                                                  ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2,
                                            color: ColorCodes.hintcolor,
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
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      !widget.isViewProfile
                          ? Singleton.instance.objLoginUser.name
                          : Singleton.instance.objSelectedBlogUser.name,
                      textAlign: TextAlign.center,
                      style: Singleton.instance.setTextStyle(
                        fontSize: TextSize.text_24,
                        fontFamily: Constant.robotoCondensedFontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    !widget.isViewProfile
                        ? Singleton.instance.objLoginUser.hometown
                        : Singleton.instance.objSelectedBlogUser.hometown,
                    style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_14,
                      fontFamily: Constant.robotoFontFamily,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: widget.isViewProfile ? false : true,
                        child: Container(
                          //height: 50,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          width: double.infinity,
                          color: ColorCodes.navbar,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "options".toUpperCase(),
                                style: Singleton.instance.setTextStyle(
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          height: 2,
                          color: Colors.white,
                        ),
                        itemCount: arrOptions.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var strOption = arrOptions[index];

                          return GestureDetector(
                            onTap: () async {
                              if (strOption == "Edit Profile") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfileScreen()),
                                ).then((value) {
                                  setState(() {
                                    callGetUserProfileAPI(
                                        context,
                                        Singleton.instance.objLoginUser.id
                                            .toString());
                                  });
                                });
                              } else if (strOption == "Favorited Videos") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FavouritedVideosScreen()),
                                );
                              } else if (strOption == "Logout") {
                                var isWantToLogout = await Singleton.instance
                                    .showAlertDialogWithOptions(
                                        context,
                                        Constant.appName,
                                        "Are you sure you want to Logout?",
                                        Strings.yes,
                                        Strings.no);

                                if (isWantToLogout != null &&
                                    isWantToLogout == true) {
                                  Singleton.instance.callLogoutAPI(context);
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              color: ColorCodes.unselectedColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          strOption,
                                          style:
                                              Singleton.instance.setTextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: TextSize.text_14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  (strOption == "Favorited Videos" ||
                                          strOption == "Logout")
                                      ? Container()
                                      : Image.asset(
                                          "",
                                          height: 20,
                                          width: 20,
                                          color: ColorCodes.hintcolor,
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      //*****************************
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        //height: 50,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        width: double.infinity,
                        color: ColorCodes.navbar,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Strings.k9Information.toUpperCase(),
                              style: Singleton.instance.setTextStyle(
                                textColor: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            widget.isViewProfile
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      Singleton.instance.objSelectedBreed =
                                          Categories(
                                              id: 0, name: "", description: "");
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          Strings.add.toUpperCase(),
                                          style:
                                              Singleton.instance.setTextStyle(
                                            textColor: ColorCodes.yellow,
                                            fontWeight: FontWeight.bold,
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
                      (Singleton.instance.arrUserK9.isEmpty)
                          ? Container(
                              width: double.infinity,
                              color: ColorCodes.unselectedColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 16),
                                    child: Text(
                                      !widget.isViewProfile
                                          ? "You have no k9 information"
                                          : "${Singleton.instance.objSelectedBlogUser.name} has no k9 information",
                                      textAlign: TextAlign.center,
                                      style: Singleton.instance.setTextStyle(
                                          fontSize: TextSize.text_14,
                                          fontFamily:
                                              Constant.robotoFontFamily),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 2,
                                color: Colors.white,
                              ),
                              itemCount: Singleton.instance.arrUserK9.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                var objK9Info =
                                    Singleton.instance.arrUserK9[index];

                                return Container(
                                  width: double.infinity,
                                  color: ColorCodes.unselectedColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              objK9Info.name,
                                              style: Singleton.instance
                                                  .setTextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: TextSize.text_14,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              objK9Info.breed,
                                              style: Singleton.instance
                                                  .setTextStyle(
                                                textColor:
                                                    ColorCodes.textColorGray,
                                                fontSize: TextSize.text_14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Row(
                                        children: [
                                          widget.isViewProfile
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () {},
                                                  child: Image.asset(
                                                    "",
                                                    height: 20,
                                                    width: 20,
                                                    color: ColorCodes.hintcolor,
                                                  ),
                                                ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          widget.isViewProfile
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () {
                                                    Singleton.instance
                                                        .showAlertDialogWithOptions(
                                                            context,
                                                            Constant.appName,
                                                            "Are you sure you want to delete k9 info?",
                                                            Strings.yes,
                                                            Strings.no)
                                                        .then((value) {
                                                      if (value == true) {
                                                        deleteExistingK9InfoAPI(
                                                            objK9Info.id
                                                                .toString());
                                                      }
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    "",
                                                    height: 20,
                                                    width: 20,
                                                    color: ColorCodes.hintcolor,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                      //***********************
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              width: double.infinity,
                              color: ColorCodes.navbar,
                              child: Text(
                                Strings.communityActivity.toUpperCase(),
                                style: Singleton.instance.setTextStyle(
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              color: ColorCodes.unselectedColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    child: Text(
                                      !widget.isViewProfile
                                          ? (Singleton.instance.objLoginUser
                                                      .lessionCount <
                                                  0)
                                              ? "You have posted 0 time since you joined"
                                              : (Singleton.instance.objLoginUser
                                                          .blogCount >
                                                      1)
                                                  ? "You have posted ${Singleton.instance.objLoginUser.blogCount} times since you joined"
                                                  : "You have posted ${Singleton.instance.objLoginUser.blogCount} time since you joined"
                                          : (Singleton
                                                      .instance
                                                      .objSelectedBlogUser
                                                      .lessionCount <
                                                  0)
                                              ? "${Singleton.instance.objSelectedBlogUser.name} has posted 0 time since you joined"
                                              : (Singleton
                                                          .instance
                                                          .objSelectedBlogUser
                                                          .blogCount >
                                                      1)
                                                  ? "${Singleton.instance.objSelectedBlogUser.name} has posted ${Singleton.instance.objSelectedBlogUser.blogCount} times since you joined"
                                                  : "${Singleton.instance.objSelectedBlogUser.name} has posted ${Singleton.instance.objSelectedBlogUser.blogCount} time since you joined",
                                      textAlign: TextAlign.center,
                                      style: Singleton.instance.setTextStyle(
                                          fontSize: TextSize.text_14,
                                          fontFamily:
                                              Constant.robotoFontFamily),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 25),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (!widget.isViewProfile) {
                                          if (Singleton.instance.objLoginUser
                                                  .blogCount >
                                              0) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CommunityScreen(
                                                  false,
                                                  Singleton
                                                      .instance.objLoginUser.id
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          if (Singleton
                                                  .instance
                                                  .objSelectedBlogUser
                                                  .blogCount >
                                              0) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CommunityScreen(
                                                  false,
                                                  Singleton.instance
                                                      .objSelectedBlogUser.id
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 2.0,
                                                color: ColorCodes.titleBar),
                                          ),
                                        ),
                                        child: Text(
                                          Strings.seeAllPosts.toUpperCase(),
                                          style:
                                              Singleton.instance.setTextStyle(
                                            fontSize: TextSize.text_13,
                                            textColor: ColorCodes.titleBar,
                                            fontWeight: FontWeight.bold,
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
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            width: double.infinity,
                            color: ColorCodes.navbar,
                            child: Text(
                              Strings.learningInProgress.toUpperCase(),
                              style: Singleton.instance.setTextStyle(
                                textColor: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: ColorCodes.unselectedColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 16),
                                  child: Text(
                                    !widget.isViewProfile
                                        ? (Singleton.instance.objLoginUser
                                                    .lessionCount <
                                                0)
                                            ? "You have completed 0 course"
                                            : (Singleton.instance.objLoginUser
                                                        .lessionCount >
                                                    1)
                                                ? "You have completed ${Singleton.instance.objLoginUser.lessionCount} courses"
                                                : "You have completed ${Singleton.instance.objLoginUser.lessionCount} course"
                                        : (Singleton
                                                    .instance
                                                    .objSelectedBlogUser
                                                    .lessionCount <
                                                0)
                                            ? "${Singleton.instance.objSelectedBlogUser.name} has completed 0 course"
                                            : (Singleton
                                                        .instance
                                                        .objSelectedBlogUser
                                                        .lessionCount >
                                                    1)
                                                ? "${Singleton.instance.objSelectedBlogUser.name} has completed ${Singleton.instance.objSelectedBlogUser.lessionCount} courses"
                                                : "${Singleton.instance.objSelectedBlogUser.name} has completed ${Singleton.instance.objSelectedBlogUser.lessionCount} course",
                                    textAlign: TextAlign.center,
                                    style: Singleton.instance.setTextStyle(
                                        fontSize: TextSize.text_14,
                                        fontFamily: Constant.robotoFontFamily),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
      ),
    );
  }

  Future<void> callGetUserProfileAPI(
      BuildContext context, String userID) async {
    LoginReposnseModel loginResponseModel;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Map<String, String> body;
    body = {
      ApiParamters.device_type_auth: Singleton.instance.deviceType(),
      ApiParamters.user_secret: userID
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.get_user_profile);

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            loginResponseModel =
                LoginReposnseModel.fromJson(json.decode(response.body));

            UserProfileResponse profileResponseModel =
                UserProfileResponse.fromJson(json.decode(response.body));
            Singleton.instance.arrUserK9 = profileResponseModel.payload.k9Info;

            var userData = loginResponseModel.payload;

            String userCommonData = jsonEncode(
                UserModel.fromJson(json.decode(response.body)['payload']));

            if (userData != null) {
              UserModel userModel =
                  UserModel.fromJson(json.decode(response.body)['payload']);
              if (!widget.isViewProfile) {
                Singleton.instance.objLoginUser = userModel;
                Singleton.instance.setUserModel(userCommonData);

                Singleton.instance.AuthToken =
                    Singleton.instance.objLoginUser.token;
                Singleton.instance.userProfile =
                    loginResponseModel.payload.profileImage;
              } else {
                Singleton.instance.objSelectedBlogUser = userModel;
              }

              setState(() {});
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

  Future<void> deleteExistingK9InfoAPI(String dogID) async {
    late Map<String, String> body;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Singleton.instance.showDefaultProgress();

    body = {
      ApiParamters.dog_id: dogID,
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.delete_k9);

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (response.statusCode == 200) {
            setState(() {
              callGetUserProfileAPI(
                  context, Singleton.instance.objLoginUser.id.toString());
            });
          } else if (response.statusCode == 500) {
            Singleton.instance.hideProgress();
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else if (response.statusCode == 501) {
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          } else {
            Singleton.instance.hideProgress();
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
