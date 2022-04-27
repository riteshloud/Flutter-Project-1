// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../helpers/api_constant.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/constant.dart';
import '../../../helpers/singleton.dart';
import '../../../helpers/strings.dart';
import '../../../models/get_course_response_model.dart';
import '../../../service/api_service.dart';
import '../../../widgets/common/safearea_widget.dart';
import '../../../widgets/searchbar.dart';

class CourseWorkoutScreen extends StatefulWidget {
  int selectedTabIndex;
  CourseWorkoutScreen({Key? key, required this.selectedTabIndex})
      : super(key: key);

  @override
  _CourseWorkOutScreenState createState() => _CourseWorkOutScreenState();
}

class _CourseWorkOutScreenState extends State<CourseWorkoutScreen>
    with SingleTickerProviderStateMixin {
  bool isCoursesTapped = true;
  // late MyCourse mycourse;

  late Payload getcoursePayload = Payload();

  doneFunction(int search, String keyword) {
    Singleton.instance.searchedCourseKeyword = keyword;
    if (search == 1 && keyword.isNotEmpty) {
      //if (isCoursesTapped) {
      Singleton.instance.isSearchingCourse = true;
      callSearchCourseAPI(keyword);
      //}
    } else if (search == 0 && keyword.isEmpty) {
      Singleton.instance.isSearchingCourse = false;
      callGetcourseListAPI(false);
    }
  }

  refreshCourseList() {}

  late TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  late List<String> tabList;
  var isPageCanChanged = true;

  initTabData() {
    tabList = [Strings.courses.toUpperCase(), Strings.workout.toUpperCase()];
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("COURSE WORKOUT INIT STATE CALLED");
    }
    initTabData();
    mTabController = TabController(
      length: tabList.length,
      vsync: this,
      initialIndex: widget.selectedTabIndex,
    );
    if (mTabController.index == 0) {
      isCoursesTapped = true;
    } else {
      isCoursesTapped = false;
    }

    mTabController.addListener(() {
      //TabBar listener
      if (mTabController.indexIsChanging) {
        onPageChange(mTabController.index, p: mPageController);

        if (mTabController.index == 0) {
          isCoursesTapped = true;
        } else {
          isCoursesTapped = false;
        }
        setState(() {});
      }
    });

    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet != null && intenet) {
        callGetcourseListAPI(true);
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
                  Strings.allCourses,
                  doneFunction,
                  refreshCourseList,
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
                    isCoursesTapped
                        ? (getcoursePayload.course == null)
                            ? "0 course available"
                            : (getcoursePayload.course!.length > 1)
                                ? "${getcoursePayload.course!.length} courses available"
                                : "${getcoursePayload.course!.length} course available"
                        : (getcoursePayload.workout == null)
                            ? "0 workout available"
                            : (getcoursePayload.workout!.length > 1)
                                ? "${getcoursePayload.workout!.length} workouts available"
                                : "${getcoursePayload.workout!.length} workout available",
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
                    /* return getcoursePayload != null
                        ? index == 0
                            ? courses()
                            : courses()
                        : Container();*/
                    return mTabController.index == 0
                        ? (getcoursePayload.course == null)
                            ? const Center(
                                child: null,
                              )
                            : courses()
                        : (getcoursePayload.workout == null)
                            ? const Center(
                                child: null,
                              )
                            : workout();
                  },
                ),
              )
            ],
          ),
        ),
      ),
      color: ColorCodes.navbar,
    );
  }

  Future<void> _pullRefresh() async {
    if (Singleton.instance.searchedCourseKeyword.isNotEmpty) {
      callSearchCourseAPI(Singleton.instance.searchedCourseKeyword);
    } else {
      callGetcourseListAPI(true);
    }
  }

  Widget courses() {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: ListView.builder(
          padding: const EdgeInsets.all(0.0),
          shrinkWrap: true,
          itemCount: getcoursePayload.course!.length,
          itemBuilder: (ctx, i) {
            return GestureDetector(
                onTap: () {},
                child: CachedNetworkImage(
                  imageUrl: getcoursePayload.course![i].imageFullUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 10, top: 8),
                    padding: const EdgeInsets.all(0),
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          foregroundDecoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Container(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              children: [
                                //  if (items[i].isTopPicked) pickedForYou(items[i]),
                                lockedItemForCourse(
                                    getcoursePayload.course![i]),
                              ],
                            ),
                            titleDetailForCourse(getcoursePayload.course![i]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 10, top: 8),
                    child: Singleton.instance.widePlaceholderWidget(
                      MediaQuery.of(context).size.height * 0.25,
                      MediaQuery.of(context).size.width - 32,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 10, top: 8),
                    child: Singleton.instance.widePlaceholderWidget(
                      MediaQuery.of(context).size.height * 0.25,
                      MediaQuery.of(context).size.width - 32,
                    ),
                  ),
                ));
          }),
    );
  }

  Widget workout() {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: ListView.builder(
          padding: const EdgeInsets.all(0.0),
          shrinkWrap: true,
          // itemCount: mycourse.getCourses.length,
          itemCount: getcoursePayload.workout!.length,
          itemBuilder: (ctx, i) {
            return GestureDetector(
                onTap: () {},
                child: CachedNetworkImage(
                  imageUrl: getcoursePayload.workout![i].imageFullUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 10, top: 8),
                    padding: const EdgeInsets.all(0),
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          foregroundDecoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Container(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              children: [
                                lockedItemForWorkout(
                                    getcoursePayload.workout![i]),
                              ],
                            ),
                            titleDetailForWorkout(getcoursePayload.workout![i]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 10, top: 8),
                    child: Singleton.instance.widePlaceholderWidget(
                      MediaQuery.of(context).size.height * 0.25,
                      MediaQuery.of(context).size.width,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 10, top: 8),
                    child: Singleton.instance.widePlaceholderWidget(
                      MediaQuery.of(context).size.height * 0.25,
                      MediaQuery.of(context).size.width,
                    ),
                  ),
                ));
          }),
    );
  }

  Widget lockedItemForCourse(Course item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (item.is_favorite == 1) {
                    removeCourseFromFavouriteAPI(item.secret ?? "");
                  } else {
                    addCourseToFavouriteAPI(item.secret ?? "");
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.only(right: 10),
                  child: Visibility(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(item.is_favorite == 1 ? "" : "",
                          height: 22, width: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget titleDetailForCourse(Course item) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 16),
        child: Text(
          item.title!,
          style: Singleton.instance.setTextStyle(
              textColor: Colors.white,
              fontSize: TextSize.text_18,
              fontFamily: Constant.robotoCondensedFontFamily,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget lockedItemForWorkout(Course item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (item.is_favorite == 1) {
                    removeCourseFromFavouriteAPI(item.secret ?? "");
                  } else {
                    addCourseToFavouriteAPI(item.secret ?? "");
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.only(right: 10),
                  child: Visibility(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(item.is_favorite == 1 ? "" : "",
                          height: 22, width: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget titleDetailForWorkout(Course item) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 16),
        child: Text(
          item.title!,
          style: Singleton.instance.setTextStyle(
              textColor: Colors.white,
              fontSize: TextSize.text_18,
              fontFamily: Constant.robotoCondensedFontFamily,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> callGetcourseListAPI(bool isWantToShoProgress) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    if (isWantToShoProgress) {
      Singleton.instance.showDefaultProgress();
    }

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.getCourseList);

    ApiService.getCallwithHeader(url, header, context).then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            String commondata = jsonEncode(
                Payload.fromJson(json.decode(response.body)['payload']));
            Map userMap = jsonDecode(commondata);
            getcoursePayload = Payload.fromJson(userMap);

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

  Future<void> callSearchCourseAPI(String keyword) async {
    late Map<String, String> body;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Singleton.instance.showDefaultProgress();
    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.searchCourse);

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
            String commondata = jsonEncode(
                Payload.fromJson(json.decode(response.body)['payload']));
            Map userMap = jsonDecode(commondata);
            getcoursePayload = Payload.fromJson(userMap);
            setState(() {});
          } else if (response.statusCode == 500) {
            Singleton.instance.showAInvalidTokenAlert(
                context, Constant.alert, responseData["message"]);
          } else if (response.statusCode == 501) {
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          } else {
            getcoursePayload = Payload();
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
        if (kDebugMode) {
          if (kDebugMode) {
            print("EMPTY RESPONSE");
          }
        }
      }
    });
  }

  Future<void> addCourseToFavouriteAPI(String secret) async {
    late Map<String, String> body;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Singleton.instance.showDefaultProgress();

    body = {
      ApiParamters.course_secret: secret,
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.addFavourite);

    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (response.statusCode == 200) {
            if (Singleton.instance.isSearchingCourse) {
              callSearchCourseAPI(Singleton.instance.searchedCourseKeyword);
            } else {
              callGetcourseListAPI(true);
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
          response.success = false;
          response.message = "Please check internet connection";
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

  Future<void> removeCourseFromFavouriteAPI(String secret) async {
    late Map<String, String> body;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Singleton.instance.showDefaultProgress();

    body = {
      ApiParamters.course_secret: secret,
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.removeFavourite);

    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (response.statusCode == 200) {
            if (Singleton.instance.isSearchingCourse) {
              callSearchCourseAPI(Singleton.instance.searchedCourseKeyword);
            } else {
              callGetcourseListAPI(true);
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
          response.success = false;
          response.message = "Please check internet connection";
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
