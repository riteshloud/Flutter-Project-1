// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helpers/singleton.dart';
import '../../../helpers/constant.dart';
import '../../../helpers/strings.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/api_constant.dart';

import '../../../service/api_service.dart';

import '../../../models/favourite_response_model.dart';
import '../../../models/get_course_response_model.dart';

import '../../../widgets/common/safearea_widget.dart';
import '../../../widgets/searchbar.dart';

class FavoriteCourseWorkoutScreen extends StatefulWidget {
  const FavoriteCourseWorkoutScreen({Key? key}) : super(key: key);

  @override
  _FavoriteCourseWorkoutScreenState createState() =>
      _FavoriteCourseWorkoutScreenState();
}

class _FavoriteCourseWorkoutScreenState
    extends State<FavoriteCourseWorkoutScreen>
    with SingleTickerProviderStateMixin {
  int indexNo = 0;
  // late MyCourse mycourse;

  late FavouriteListPayload objFavourite = FavouriteListPayload();
  List<Course> arrCourses = [];

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print("FAVOURITE COURSE WORKOUT INIT STATE CALLED");
    }
    initTabData();
    mTabController = TabController(
      length: tabList.length,
      vsync: this,
    );
    mTabController.addListener(() {
      //TabBar listener
      if (mTabController.indexIsChanging) {
        onPageChange(mTabController.index, p: mPageController);

        indexNo = mTabController.index;
        setState(() {});
      }
    });

    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet != null && intenet) {
        callGetFavouriteListAPI(true);
      } else {
        Singleton.instance.showAlertDialogWithOkAction(
            context, Constant.appName, Constant.noInternet);
      }
    });
  }

  onPageChange(int index, {PageController? p, TabController? t}) async {
    if (p != null) {
      //determine which switch is
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: const Duration(milliseconds: 500),
          curve: Curves
              .ease); //Wait for pageview to switch, then release pageivew listener
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //Switch Tabbar
    }
  }

  doneFunction(int search, String keyword) {
    Singleton.instance.searchedFavouriteCourseKeyword = keyword;
    if (search == 1 && keyword.isNotEmpty) {
      //if (isCoursesTapped) {
      Singleton.instance.isSearchingFavouriteCourse = true;
      callSearchFromFavouriteListAPI(keyword);
      //}
    } else if (search == 0 && keyword.isEmpty) {
      Singleton.instance.isSearchingFavouriteCourse = false;
      callGetFavouriteListAPI(false);
    }
  }

  refreshFavouriteCourseList() {}

  late TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  late List<String> tabList;
  var currentPage = 0;
  var isPageCanChanged = true;

  initTabData() {
    tabList = [
      Strings.saved.toUpperCase(),
      Strings.inProgress.toUpperCase(),
      Strings.completed.toUpperCase()
    ];
  }

  /*
  @override
  void initState() {
    super.initState();
    initTabData();
    mTabController = TabController(
      length: tabList.length,
      vsync: this,
    );
    mTabController.addListener(() {
      //TabBar listener
      if (mTabController.indexIsChanging) {
        print(mTabController.index);
        onPageChange(mTabController.index, p: mPageController);
      }
    });
  }
  */

  /*
  @override
  void didChangeDependencies() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {});
    // callProvider();

    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet != null && intenet) {
        callGetFavouriteListAPI(true);
      } else {
        Singleton.instance.showAlertDialogWithOkAction(
            context, Constant.appName, Constant.noInternet);
      }
    });

    super.didChangeDependencies();
  }
  */

  /*
  onPageChange(int index, {PageController? p, TabController? t}) async {
    if (p != null) {
      //determine which switch is
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: const Duration(milliseconds: 500),
          curve: Curves
              .ease); //Wait for pageview to switch, then release pageivew listener
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //Switch Tabbar
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      child: Scaffold(
        body: Container(
          height: double.maxFinite,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SearchBarWidget(
                  Strings.searchCourses,
                  doneFunction,
                  Strings.myCourses,
                  doneFunction,
                  refreshFavouriteCourseList,
                  false,
                  false,
                  true),
              Container(
                color: ColorCodes.navbar,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: ColorCodes.yellow,
                    isScrollable: true,
                    controller: mTabController,
                    labelColor: ColorCodes.yellow,
                    unselectedLabelColor: Colors.white,
                    labelStyle: Singleton.instance.setTextStyle(
                        fontSize: TextSize.text_13,
                        fontFamily: Constant.oxaniumFontFamily,
                        fontWeight: FontWeight.bold),
                    tabs: tabList.map((item) {
                      return Tab(
                        iconMargin: const EdgeInsets.all(0),
                        text: item,
                      );
                    }).toList(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    (indexNo == 0)
                        ? (objFavourite.total_saved ?? 0) > 1
                            ? (objFavourite.total_saved.toString() +
                                " " +
                                "courses in the list")
                            : (objFavourite.total_saved == null)
                                ? " 0 course in the list"
                                : (objFavourite.total_saved.toString() +
                                    " " +
                                    "course in the list")
                        : (indexNo == 1)
                            ? (objFavourite.total_in_process ?? 0) > 1
                                ? (objFavourite.total_in_process.toString() +
                                    " " +
                                    "courses in the list")
                                : (objFavourite.total_in_process == null)
                                    ? "0 course in the list"
                                    : (objFavourite.total_in_process
                                            .toString() +
                                        " " +
                                        "course in the list")
                            : (indexNo == 2)
                                ? (objFavourite.total_completed ?? 0) > 1
                                    ? (objFavourite.total_completed.toString() +
                                        " " +
                                        "courses in the list")
                                    : (objFavourite.total_completed == null)
                                        ? "0 course in the list"
                                        : (objFavourite.total_completed
                                                .toString() +
                                            " " +
                                            "course in the list")
                                : "",
                    textAlign: TextAlign.start,
                    style: Singleton.instance.setTextStyle(
                        textColor: ColorCodes.noOfCoursesColor,
                        fontSize: TextSize.text_14,
                        fontFamily: Constant.robotoFontFamily,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: tabList.length,
                  onPageChanged: (index) {
                    if (isPageCanChanged) {
                      onPageChange(index);
                    }
                  },
                  controller: mPageController,
                  itemBuilder: (BuildContext context, int index) {
                    //indexNo = index;

                    if (objFavourite != null) {
                      if (indexNo == 0) {
                        arrCourses = objFavourite.saved ?? [];
                      } else if (indexNo == 1) {
                        arrCourses = objFavourite.in_process ?? [];
                      } else if (indexNo == 2) {
                        arrCourses = objFavourite.completed ?? [];
                      }
                    }

                    //return index == 0 ? courses() : courses();
                    return courses();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      color: ColorCodes.navbar,
    );
  }

  Future<void> _pullRefresh() async {
    if (Singleton.instance.searchedFavouriteCourseKeyword.isNotEmpty) {
      callSearchFromFavouriteListAPI(
          Singleton.instance.searchedFavouriteCourseKeyword);
    } else {
      callGetFavouriteListAPI(true);
    }
  }

  Widget courses() {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        itemCount: arrCourses.length,
        itemBuilder: (ctx, i) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin:
                  const EdgeInsets.only(left: 16, right: 8, bottom: 10, top: 8),
              padding: const EdgeInsets.all(0),
              child: Stack(
                children: [
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: setImage(arrCourses[i]),
                              flex: 2,
                            ),
                            //const SizedBox(width: 16,),
                            Flexible(
                              child: titleItem(arrCourses[i]),
                              flex: 3,
                            ),
                          ],
                        ),
                      ),
                      moreDetail(arrCourses[i], i)
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
            color: ColorCodes.textColorGray,
          );
        },
      ),
    );
  }

  Widget setImage(Course item) {
    return CachedNetworkImage(
      imageUrl: item.imageFullUrl ?? "",
      imageBuilder: (context, imageProvider) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: MediaQuery.of(context).size.width / 3.1,
          height: MediaQuery.of(context).size.width / 4.7,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Singleton.instance.widePlaceholderWidget(
        MediaQuery.of(context).size.height * 0.3,
        MediaQuery.of(context).size.width,
      ),
      errorWidget: (context, url, error) =>
          Singleton.instance.widePlaceholderWidget(
        MediaQuery.of(context).size.height * 0.3,
        MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget titleItem(Course item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Singleton.instance.setTextStyle(
                textColor: Colors.white,
                fontSize: TextSize.text_16,
                fontWeight: FontWeight.w700,
                fontFamily: Constant.robotoCondensedFontFamily),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            item.noOfVideos.toString() + " " + Strings.videos,
            style: Singleton.instance.setTextStyle(
                textColor: ColorCodes.hintcolor,
                fontSize: TextSize.text_12,
                fontWeight: FontWeight.w700,
                fontFamily: Constant.oxaniumFontFamily),
          ),
          Visibility(
            visible: indexNo == 2 ? true : false,
            child: const SizedBox(
              height: 6,
            ),
          ),
          Visibility(
            visible: indexNo == 2 ? true : false,
            child: Row(
              children: [
                Image.asset(
                  "",
                  width: 14,
                  height: 14,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  (item.completedAt == null)
                      ? Strings.completedOn
                      : Strings.completedOn +
                          " " +
                          DateFormat("MM/dd/yyyy").format(
                              DateTime.parse(item.completedAt.toString())) +
                          " ",
                  style: Singleton.instance.setTextStyle(
                      textColor: ColorCodes.yellow,
                      fontSize: TextSize.text_12,
                      fontWeight: FontWeight.w700,
                      fontFamily: Constant.robotoCondensedFontFamily),
                )
              ],
            ),
          ),
          Visibility(
            visible: indexNo == 1 ? true : false,
            child: const SizedBox(
              height: 10,
            ),
          ),
          Visibility(
            visible: indexNo == 1 ? true : false,
            child: LinearProgressIndicator(
              value: ((item.videoProgress ?? 100) / 100), //0.5,
              backgroundColor: ColorCodes.textColorGray,
              color: ColorCodes.yellow,
              semanticsLabel: 'Linear progress indicator',
            ),
          ),
        ],
      ),
    );
  }

  Widget moreDetail(Course item, int pos) {
    return GestureDetector(
      onTap: () {},
      onTapDown: (details) {
        if (pos == 0) {
          if (arrCourses.length == 1) {
            _showPopupMenuWithoutTopAndBottom(details, pos);
          } else {
            _showPopupMenuWithoutTop(details, pos);
          }
        } else if (pos == (arrCourses.length - 1)) {
          _showPopupMenuWithoutBottom(details, pos);
        } else {
          _showPopupMenuWithAllOptions(details, pos);
        }
      },
      child: Container(
          alignment: Alignment.topRight,
          child: const Icon(
            Icons.more_vert,
            size: 28,
            color: Colors.white,
          )),
    );
  }

  _showPopupMenuWithoutTopAndBottom(TapDownDetails details, int pos) {
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
            value: 3,
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "",
                  height: 21,
                  width: 18,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  Strings.removeFromWatchlist,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_14,
                      fontFamily: Constant.robotoFontFamily,
                      fontWeight: FontWeight.normal,
                      textColor: ColorCodes.textColorGray),
                ),
              ],
            ))
      ],
      elevation: 8.0,
    ).then<void>((getCourseselected) async {
      if (getCourseselected == 1) {
        moveToTopAPI(arrCourses[pos].myCourseSecret ?? "");
      } else if (getCourseselected == 2) {
        moveToBottomAPI(arrCourses[pos].myCourseSecret ?? "");
      } else if (getCourseselected == 3) {
        removeCourseFromFavouriteAPI(arrCourses[pos].myCourseSecret ?? "");
      }
    });
  }

  _showPopupMenuWithAllOptions(TapDownDetails details, int pos) {
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
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "",
                  height: 24,
                  width: 18,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  Strings.moveToTop,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_14,
                      fontFamily: Constant.robotoFontFamily,
                      fontWeight: FontWeight.normal,
                      textColor: ColorCodes.textColorGray),
                ),
              ],
            )),
        PopupMenuItem<int>(
            value: 2,
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "",
                  height: 21,
                  width: 18,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  Strings.moveToBottom,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_14,
                      fontFamily: Constant.robotoFontFamily,
                      fontWeight: FontWeight.normal,
                      textColor: ColorCodes.textColorGray),
                ),
              ],
            )),
        PopupMenuItem<int>(
            value: 3,
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "",
                  height: 21,
                  width: 18,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  Strings.removeFromWatchlist,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_14,
                      fontFamily: Constant.robotoFontFamily,
                      fontWeight: FontWeight.normal,
                      textColor: ColorCodes.textColorGray),
                ),
              ],
            ))
      ],
      elevation: 8.0,
    ).then<void>((getCourseselected) async {
      if (getCourseselected == 1) {
        moveToTopAPI(arrCourses[pos].myCourseSecret ?? "");
      } else if (getCourseselected == 2) {
        moveToBottomAPI(arrCourses[pos].myCourseSecret ?? "");
      } else if (getCourseselected == 3) {
        removeCourseFromFavouriteAPI(arrCourses[pos].myCourseSecret ?? "");
      }
    });
  }

  _showPopupMenuWithoutTop(TapDownDetails details, int pos) {
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
            value: 2,
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "",
                  height: 21,
                  width: 18,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  Strings.moveToBottom,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_14,
                      fontFamily: Constant.robotoFontFamily,
                      fontWeight: FontWeight.normal,
                      textColor: ColorCodes.textColorGray),
                ),
              ],
            )),
        PopupMenuItem<int>(
            value: 3,
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "",
                  height: 21,
                  width: 18,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  Strings.removeFromWatchlist,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_14,
                      fontFamily: Constant.robotoFontFamily,
                      fontWeight: FontWeight.normal,
                      textColor: ColorCodes.textColorGray),
                ),
              ],
            ))
      ],
      elevation: 8.0,
    ).then<void>((getCourseselected) async {
      if (getCourseselected == 1) {
        moveToTopAPI(arrCourses[pos].myCourseSecret ?? "");
      } else if (getCourseselected == 2) {
        moveToBottomAPI(arrCourses[pos].myCourseSecret ?? "");
      } else if (getCourseselected == 3) {
        removeCourseFromFavouriteAPI(arrCourses[pos].myCourseSecret ?? "");
      }
    });
  }

  _showPopupMenuWithoutBottom(TapDownDetails details, int pos) {
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
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "",
                  height: 24,
                  width: 18,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  Strings.moveToTop,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_14,
                      fontFamily: Constant.robotoFontFamily,
                      fontWeight: FontWeight.normal,
                      textColor: ColorCodes.textColorGray),
                ),
              ],
            )),
        PopupMenuItem<int>(
            value: 3,
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Image.asset(
                  "",
                  height: 21,
                  width: 18,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  Strings.removeFromWatchlist,
                  style: Singleton.instance.setTextStyle(
                      fontSize: TextSize.text_14,
                      fontFamily: Constant.robotoFontFamily,
                      fontWeight: FontWeight.normal,
                      textColor: ColorCodes.textColorGray),
                ),
              ],
            ))
      ],
      elevation: 8.0,
    ).then<void>((getCourseselected) async {
      if (getCourseselected == 1) {
        moveToTopAPI(arrCourses[pos].myCourseSecret ?? "");
      } else if (getCourseselected == 2) {
        moveToBottomAPI(arrCourses[pos].myCourseSecret ?? "");
      } else if (getCourseselected == 3) {
        removeCourseFromFavouriteAPI(arrCourses[pos].myCourseSecret ?? "");
      }
    });
  }

  Future<void> callGetFavouriteListAPI(bool isWantToShoProgress) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    late Map<String, String> body;
    body = {
      //ApiParamters.course_secret: secret,
    };

    if (isWantToShoProgress) {
      Singleton.instance.showDefaultProgress();
    }

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.favouriteCourseList);

    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            String responseData = jsonEncode(FavouriteListPayload.fromJson(
                json.decode(response.body)['payload']));
            Map responseMap = jsonDecode(responseData);
            objFavourite = FavouriteListPayload.fromJson(responseMap);

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

      }
    });
  }

  Future<void> callSearchFromFavouriteListAPI(String keyword) async {
    late Map<String, String> body;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Singleton.instance.showDefaultProgress();
    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.searchFavouriteCourse);

    body = {
      ApiParamters.keyword: keyword,
    };

    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            String responseData = jsonEncode(FavouriteListPayload.fromJson(
                json.decode(response.body)['payload']));
            Map responseMap = jsonDecode(responseData);
            objFavourite = FavouriteListPayload.fromJson(responseMap);
            setState(() {});
          } else if (response.statusCode == 500) {
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else if (response.statusCode == 501) {
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          } else {
            objFavourite = FavouriteListPayload();
            setState(() {});
            Singleton.instance.showAlertDialogWithOkAction(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException {
          Singleton.instance.hideProgress();
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          Singleton.instance.hideProgress();
          Singleton.instance.showSnackBar(context, responseData['message']);
        }
      } else {
        //Singleton.instance.hideProgress();

      }
    });
  }

  Future<void> removeCourseFromFavouriteAPI(String secret) async {
    late Map<String, String> body;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Singleton.instance.showDefaultProgress();

    body = {
      ApiParamters.my_course_secret: secret,
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.removeFavouriteCourse);

    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          //Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            if (Singleton.instance.isSearchingFavouriteCourse) {
              callSearchFromFavouriteListAPI(
                  Singleton.instance.searchedCourseKeyword);
            } else {
              callGetFavouriteListAPI(true);
            }
          } else if (response.statusCode == 500) {
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

      }
    });
  }

  Future<void> moveToTopAPI(String secret) async {
    late Map<String, String> body;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Singleton.instance.showDefaultProgress();

    body = {
      ApiParamters.my_course_secret: secret,
      ApiParamters.type: "top",
      ApiParamters.course_type: (indexNo == 0)
          ? "saved"
          : (indexNo == 1)
              ? "in_process"
              : (indexNo == 2)
                  ? "completed"
                  : "",
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.changeCourseOrder);

    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (response.statusCode == 200) {
            if (Singleton.instance.isSearchingFavouriteCourse) {
              callSearchFromFavouriteListAPI(
                  Singleton.instance.searchedCourseKeyword);
            } else {
              callGetFavouriteListAPI(true);
            }
          } else if (response.statusCode == 500) {
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

      }
    });
  }

  Future<void> moveToBottomAPI(String secret) async {
    late Map<String, String> body;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Singleton.instance.showDefaultProgress();

    body = {
      ApiParamters.my_course_secret: secret,
      ApiParamters.type: "bottom",
      ApiParamters.course_type: (indexNo == 0)
          ? "saved"
          : (indexNo == 1)
              ? "in_process"
              : (indexNo == 2)
                  ? "completed"
                  : "",
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.changeCourseOrder);

    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (response.statusCode == 200) {
            if (Singleton.instance.isSearchingFavouriteCourse) {
              callSearchFromFavouriteListAPI(
                  Singleton.instance.searchedCourseKeyword);
            } else {
              callGetFavouriteListAPI(true);
            }
          } else if (response.statusCode == 500) {
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

      }
    });
  }
}
