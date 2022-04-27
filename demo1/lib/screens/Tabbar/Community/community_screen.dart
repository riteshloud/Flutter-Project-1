// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'new_post_screen.dart';
import '../../../screens/Profile/profile_screen.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/constant.dart';
import '../../../helpers/singleton.dart';
import '../../../helpers/strings.dart';
import '../../../helpers/api_constant.dart';
import '../../../providers/community_provider_model.dart';
import '../../../widgets/common/safearea_widget.dart';
import '../../../widgets/searchbar.dart';
import '../../../service/api_service.dart';

class CommunityScreen extends StatefulWidget {
  var fromTabbar = true;
  String userID;

  CommunityScreen(this.fromTabbar, this.userID, {Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final FocusNode commentNode = FocusNode();
  List<String> spamComments = [
    "False information",
    "Violence",
    "Unauthorised content",
    "Just don't like it",
    "some fraud",
    "Spam",
    "Something else"
  ];

  var pageNo = 1;

  doneFunction(int search, String keyword) {
    Singleton.instance.searchedCommunityKeyword = keyword;
    if (search == 1 && keyword.isNotEmpty) {
      Singleton.instance.isSearchingCommunity = true;
      callPostListAPI(false, 1, keyword);
    } else if (search == 0 && keyword.isEmpty) {
      Singleton.instance.isSearchingCommunity = false;
      callPostListAPI(false, 1, "");
    }
  }

  List<TextEditingController> commentController = [];

  makeAPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPostScreen()),
    ).then((value) {
      Singleton.instance.isInternetConnected().then((intenet) {
        if (intenet != null && intenet) {
          pageNo = 1;
          callPostListAPI(true, 1, "");
        } else {
          Singleton.instance.showAlertDialogWithOkAction(
              context, Constant.appName, Constant.noInternet);
        }
      });
    });
  }

  refreshCommunityList() {}

  late CommunityProviderModel communityProvider;
  List<Blogs> blogList = [];

  @override
  void initState() {
    if (kDebugMode) {
      print("COMMUNITY INIT STATE CALLED");
    }

    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet != null && intenet) {
        callPostListAPI(true, 1, "");
      } else {
        Singleton.instance.showAlertDialogWithOkAction(
            context, Constant.appName, Constant.noInternet);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              color: Colors.black,
              child: SearchBarWidget(
                  "Search",
                  doneFunction,
                  Strings.community.toUpperCase(),
                  makeAPost,
                  refreshCommunityList,
                  true,
                  !widget.fromTabbar,
                  widget.fromTabbar),
            ),
            blogList.isNotEmpty
                ? postList()
                : Center(
                    child: Text(
                      "No data available",
                      style: Singleton.instance
                          .setTextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
          ],
        ),
      ),
      color: ColorCodes.navbar,
    );
  }

  Future<void> _pullRefresh() async {
    if (Singleton.instance.searchedCommunityKeyword.isNotEmpty) {
      callPostListAPI(
          true, pageNo, Singleton.instance.searchedCommunityKeyword);
    } else {
      callPostListAPI(true, pageNo, "");
    }
  }

  Widget postList() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              pageNo++;
              if (pageNo <= communityProvider.payload!.totalPage!) {
                callPostListAPI(false, pageNo, "");
                // start loading data
              }
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              itemCount: blogList.length,
              itemBuilder: (ctx, i) {
                commentController.add(TextEditingController());
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    widget.fromTabbar
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                      isViewProfile: (blogList[
                                                                      i]
                                                                  .user!
                                                                  .id ==
                                                              Singleton
                                                                  .instance
                                                                  .objLoginUser
                                                                  .id)
                                                          ? false
                                                          : true,
                                                      userID: blogList[i]
                                                          .user!
                                                          .id
                                                          .toString(),
                                                    )),
                                          )
                                        // ignore: avoid_print
                                        : print("BBBB");
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22.0),
                                    child: (blogList[i].user!.profileImage ==
                                            null)
                                        ? Singleton.instance
                                            .placeholderWidget(45, 45)
                                        : CachedNetworkImage(
                                            memCacheHeight: null,
                                            memCacheWidth: 200,
                                            imageUrl: blogList[i]
                                                    .user!
                                                    .profileImage ??
                                                "",
                                            height: 45,
                                            width: 45,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Singleton.instance
                                                    .placeholderWidget(45, 45),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Singleton.instance
                                                    .placeholderWidget(45, 45),
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      blogList[i].user!.name!,
                                      style: Singleton.instance.setTextStyle(
                                        fontFamily: Constant.robotoFontFamily,
                                        fontWeight: FontWeight.w700,
                                        fontSize: TextSize.text_14,
                                      ),
                                    ),
                                    Text(
                                      DateFormat("MMM dd").format(
                                              DateTime.parse(blogList[i]
                                                  .created_at
                                                  .toString())) +
                                          " at " +
                                          DateFormat("HH:mm a").format(
                                              DateTime.parse(blogList[i]
                                                      .created_at
                                                      .toString())
                                                  .toLocal()),
                                      style: Singleton.instance.setTextStyle(
                                          fontFamily: Constant
                                              .robotoCondensedFontFamily,
                                          fontWeight: FontWeight.w700,
                                          fontSize: TextSize.text_12,
                                          textColor: ColorCodes.hintcolor),
                                    )
                                  ],
                                )
                              ],
                            ),
                            moreDetail(i, blogList[i]),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          blogList[i].description!,
                          maxLines: 2,
                          style: Singleton.instance.setTextStyle(
                            fontFamily: Constant.robotoFontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: TextSize.text_14,
                            textColor: ColorCodes.textColorGray,
                            height: 1.5,
                          ),
                        ),
                        blogList[i].image!.isEmpty
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                                padding: const EdgeInsets.all(0),
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: CachedNetworkImage(
                                  memCacheHeight: null,
                                  memCacheWidth: 400,
                                  imageUrl: blogList[i].image ?? "",
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Singleton.instance
                                        .widePlaceholderWithGreyColorWidget(
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                            MediaQuery.of(context).size.width),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Singleton.instance
                                        .widePlaceholderWithGreyColorWidget(
                                      MediaQuery.of(context).size.height * 0.25,
                                      MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              blogList[i].comments!.length.toString() +
                                  " " +
                                  Strings.comment,
                              maxLines: 1,
                              style: Singleton.instance.setTextStyle(
                                  fontFamily: Constant.robotoFontFamily,
                                  fontWeight: FontWeight.w400,
                                  fontSize: TextSize.text_14,
                                  textColor: ColorCodes.textColorGray),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (blogList[i].comments!.isNotEmpty) {
                                  Singleton.instance.showBottomSheetWTFraction(
                                      context,
                                      showMoreComment(blogList[i]),
                                      0.5);
                                }
                              },
                              child: Text(
                                Strings.viewMore,
                                maxLines: 1,
                                style: Singleton.instance.setTextStyle(
                                    fontFamily: Constant.robotoFontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: TextSize.text_12,
                                    textColor: ColorCodes.textColorGray,
                                    textDecoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (blogList[i].comments!.isNotEmpty)
                          GestureDetector(
                            onLongPress: () {
                              Singleton.instance.showBottomSheet(context,
                                  spanCopyComment(blogList[i].comments![0]));
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(26.0),
                                  child: (blogList[i]
                                              .comments![0]
                                              .userDetail!
                                              .profileImage ==
                                          null)
                                      ? Singleton.instance
                                          .placeholderWidget(35, 35)
                                      : CachedNetworkImage(
                                          memCacheHeight: null,
                                          memCacheWidth: 200,
                                          imageUrl: blogList[i]
                                                  .comments![0]
                                                  .userDetail!
                                                  .profileImage ??
                                              "",
                                          height: 35,
                                          width: 35,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Singleton.instance
                                                  .placeholderWidget(35, 35),
                                          errorWidget: (context, url, error) =>
                                              Singleton.instance
                                                  .placeholderWidget(35, 35),
                                        ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        blogList[i]
                                            .comments![0]
                                            .userDetail!
                                            .name!,
                                        style: Singleton.instance.setTextStyle(
                                          fontFamily: Constant.robotoFontFamily,
                                          fontWeight: FontWeight.w700,
                                          fontSize: TextSize.text_14,
                                        ),
                                      ),
                                      Text(
                                        blogList[i].comments![0].comment!,
                                        style: Singleton.instance.setTextStyle(
                                            fontFamily:
                                                Constant.robotoFontFamily,
                                            fontWeight: FontWeight.w400,
                                            fontSize: TextSize.text_12,
                                            textColor:
                                                ColorCodes.textColorGray),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 8,
                        ),
                        addComment(blogList[i], commentController[i])
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 1,
                  color: ColorCodes.noOfCoursesColor,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget moreDetail(int pos, Blogs blog) {
    return Visibility(
      visible: blog.isOwn == 1 ? false : true,
      child: GestureDetector(
        onTap: () {},
        onTapDown: (details) {
          _showPopupMenu(details, pos, blog);
        },
        child: const Icon(
          Icons.more_vert,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget spanCopyComment(Comments comment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: comment.comment.toString()));

                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Image.asset(
                    "",
                    color: Colors.black,
                    width: 18,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    Strings.copy,
                    style: Singleton.instance.setTextStyle(
                        fontWeight: FontWeight.bold,
                        textColor: ColorCodes.navbar),
                  )
                ],
              ),
            ),
            Visibility(
              visible: false,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  //  callReportSpamAPI(true,blog.secret.toString(),"");
                },
                child: Row(
                  children: [
                    Image.asset(
                      "",
                      color: Colors.black,
                      width: 18,
                      height: 20,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      Strings.spamComment,
                      style: Singleton.instance.setTextStyle(
                          fontWeight: FontWeight.bold,
                          textColor: ColorCodes.navbar),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addComment(
    Blogs blog,
    TextEditingController commentController,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          // margin: const EdgeInsets.only(right: 16, top: 40),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.white, width: 2.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Singleton.instance.userProfile.isEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child:
                      Image.asset("", width: 30, height: 30, fit: BoxFit.cover))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: (Singleton.instance.userProfile.isEmpty)
                      ? Singleton.instance.placeholderWidget(30, 30)
                      : CachedNetworkImage(
                          memCacheHeight: null,
                          memCacheWidth: 200,
                          imageUrl: Singleton.instance.userProfile,
                          height: 30,
                          width: 30,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Singleton.instance.placeholderWidget(30, 30),
                          errorWidget: (context, url, error) =>
                              Singleton.instance.placeholderWidget(30, 30),
                        ),
                ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.only(left: 6),
            decoration: GlobalStyleAndDecoration.commenttextFieldBoxDecoration,
            child: TextField(
              cursorColor: Colors.black,
              onSubmitted: (value) {
                if (commentController.text.toString().isEmpty) {
                  Singleton.instance.showAlertDialogWithOkAction(
                      context, Constant.alert, "Please enter comment.");
                } else {
                  setState(() {
                    commentController.text = "";
                  });
                  callAddCommentAPI(true, value, blog.secret.toString());
                }
              },
              controller: commentController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Add a comment",
                hintStyle: Singleton.instance.setTextStyle(
                    textColor: ColorCodes.commentColor,
                    fontFamily: Constant.robotoFontFamily,
                    fontSize: TextSize.text_12,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showMoreComment(Blogs commentProvider) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ListView.separated(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        itemCount: commentProvider.comments!.length,
        itemBuilder: (ctx, i) {
          return GestureDetector(
            onTap: () {},
            onLongPress: () {
              Singleton.instance.showBottomSheet(
                  context, spanCopyComment(commentProvider.comments![i]));
            },
            child: Container(
              margin:
                  const EdgeInsets.only(left: 8, right: 4, bottom: 8, top: 8),
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: (commentProvider
                            .comments![i].userDetail!.profileImage!.isEmpty)
                        ? Singleton.instance.placeholderWidget(35, 35)
                        : CachedNetworkImage(
                            memCacheHeight: null,
                            memCacheWidth: 200,
                            imageUrl: commentProvider
                                    .comments![i].userDetail!.profileImage ??
                                "",
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Singleton.instance.placeholderWidget(35, 35),
                            errorWidget: (context, url, error) =>
                                Singleton.instance.placeholderWidget(35, 35),
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          commentProvider.comments![i].userDetail!.name!,
                          style: Singleton.instance.setTextStyle(
                            fontFamily: Constant.robotoFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: TextSize.text_14,
                          ),
                        ),
                        Text(
                          commentProvider.comments![i].comment!,
                          maxLines: 5,
                          style: Singleton.instance.setTextStyle(
                              fontFamily: Constant.robotoFontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: TextSize.text_12,
                              textColor: ColorCodes.textColorGray,
                              height: 1.5),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
            color: ColorCodes.noOfCoursesColor,
          );
        },
      ),
    );
  }

  Widget showSpamComment(Blogs commentProvider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Select Reason",
            textAlign: TextAlign.center,
            style: Singleton.instance.setTextStyle(
              fontFamily: Constant.robotoFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: TextSize.text_16,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: ListView.separated(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            itemCount: spamComments.length,
            itemBuilder: (ctx, i) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  callReportSpamAPI(
                      true, commentProvider.secret.toString(), spamComments[i]);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 8, right: 4, bottom: 8, top: 8),
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    spamComments[i],
                    style: Singleton.instance.setTextStyle(
                      fontFamily: Constant.robotoFontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: TextSize.text_14,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 1,
                color: ColorCodes.noOfCoursesColor,
              );
            },
          ),
        ),
      ],
    );
  }

  _showPopupMenu(TapDownDetails details, int pos, Blogs blog) {
    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy + 10,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      //position where you want to show the menu on screen
      items: [
        PopupMenuItem<int>(
            value: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Singleton.instance.showBottomSheetWTFraction(
                    context, showSpamComment(blog), 0.6);
              },
              child: Row(
                children: [
                  Text(
                    Strings.spamComment,
                    style: Singleton.instance.setTextStyle(
                        fontSize: TextSize.text_14,
                        fontFamily: Constant.robotoFontFamily,
                        fontWeight: FontWeight.normal,
                        textColor: ColorCodes.textColorGray),
                  ),
                ],
              ),
            )),
      ],
      elevation: 8.0,
    ).then<void>((getCourseselected) async {
      if (getCourseselected == 1) {
        Singleton.instance
            .showBottomSheetWTFraction(context, showSpamComment(blog), 0.6);
      }
    });
  }

  Future<void> callPostListAPI(
      bool isWantToShoProgress, int page, String keyword) async {
    late Map<String, String> header;
    late Map<String, String> body;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };
    if (keyword.isNotEmpty) {
      body = {
        ApiParamters.page: page.toString(),
        ApiParamters.limit: "10",
        ApiParamters.searchKeyword: keyword.toString(),
        ApiParamters.is_own: widget.fromTabbar ? "0" : widget.userID,
      };
    } else {
      body = {
        ApiParamters.page: page.toString(),
        ApiParamters.limit: "10",
        ApiParamters.is_own: widget.fromTabbar ? "0" : widget.userID,
      };
    }
    if (isWantToShoProgress) {
      Singleton.instance.showDefaultProgress();
    }
    if (page == 1) {
      blogList.clear();
    }
    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.getcommunityList);

    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            communityProvider =
                CommunityProviderModel.fromJson(json.decode(response.body));

            blogList.addAll(communityProvider.payload!.blogs!);
            setState(() {});
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

  Future<void> callAddCommentAPI(
      bool isWantToShoProgress, String comment, String blogSecret) async {
    late Map<String, String> header;
    late Map<String, String> body;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };
    body = {
      ApiParamters.blog_secret: blogSecret,
      ApiParamters.comment: comment,
    };

    if (isWantToShoProgress) {
      Singleton.instance.showDefaultProgress();
    }

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.commentOnPost);

    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            if (Singleton.instance.isSearchingCommunity) {
              callPostListAPI(
                  true, 1, Singleton.instance.searchedCommunityKeyword);
            } else {
              callPostListAPI(true, 1, "");
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
        if (kDebugMode) {
          if (kDebugMode) {
            print("EMPTY RESPONSE");
          }
        }
      }
    });
  }

  Future<void> callReportSpamAPI(
      bool isWantToShoProgress, String blogSecret, String reason) async {
    late Map<String, String> header;
    late Map<String, String> body;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };
    body = {
      ApiParamters.blog_secret: blogSecret,
      ApiParamters.reason: reason,
    };

    if (isWantToShoProgress) {
      Singleton.instance.showDefaultProgress();
    }

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.reportSpam);

    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            callPostListAPI(true, 1, "");
            if (Singleton.instance.isSearchingCommunity) {
              callPostListAPI(
                  true, 1, Singleton.instance.searchedCommunityKeyword);
            } else {
              callPostListAPI(true, 1, "");
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
        if (kDebugMode) {
          if (kDebugMode) {
            print("EMPTY RESPONSE");
          }
        }
      }
    });
  }
}
