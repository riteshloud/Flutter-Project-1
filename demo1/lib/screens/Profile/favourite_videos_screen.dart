// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/colors.dart';
import '../../helpers/singleton.dart';
import '../../helpers/constant.dart';
import '../../helpers/api_constant.dart';

import '../../models/get_course_response_model.dart';
import '../../service/api_service.dart';
import '../../widgets/common/safearea_widget.dart';

class FavouritedVideosScreen extends StatefulWidget {
  const FavouritedVideosScreen({Key? key}) : super(key: key);

  @override
  _FavouritedVideosScreenState createState() => _FavouritedVideosScreenState();
}

class _FavouritedVideosScreenState extends State<FavouritedVideosScreen> {
  List<Course> arrFavouriteCourses = [];

  @override
  void initState() {
    super.initState();
    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet != null && intenet) {
        getFavouriteListAPI(true);
      } else {
        Singleton.instance.showAlertDialogWithOkAction(
            context, Constant.appName, Constant.noInternet);
      }
    });
  }

  Future<void> _pullRefresh() async {
    getFavouriteListAPI(true);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: ColoredSafeArea(
        color: ColorCodes.navbar,
        child: Scaffold(
          appBar: Singleton.instance.CommonAppbar(
              appbarText: "Favorited Videos",
              leadingClickEvent: () {
                Navigator.pop(context, false);
              },
              endText: "",
              endTextClickEvent: () {}),
          body: arrFavouriteCourses.isEmpty
              ? Center(
                  child: Text(
                    "No data available",
                    style: Singleton.instance
                        .setTextStyle(fontWeight: FontWeight.w600),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: arrFavouriteCourses.length,
                      itemBuilder: (ctx, i) {
                        return GestureDetector(
                          onTap: () {},
                          child: CachedNetworkImage(
                            imageUrl: arrFavouriteCourses[i].imageFullUrl ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Stack(
                                        children: [
                                          //  if (items[i].isTopPicked) pickedForYou(items[i]),
                                          lockedItem(arrFavouriteCourses[i]),
                                        ],
                                      ),
                                      titleDetail(arrFavouriteCourses[i]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Singleton.instance.widePlaceholderWidget(
                                MediaQuery.of(context).size.height * 0.25,
                                MediaQuery.of(context).size.width,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Singleton.instance.widePlaceholderWidget(
                                MediaQuery.of(context).size.height * 0.25,
                                MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
        ),
      ),
    );
  }

  Widget lockedItem(Course item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (item.isTopPicked!)
        //   const Flexible(
        //     flex: 2,
        //     child: Align(
        //       alignment: Alignment.topLeft,
        //     ),
        //   ),
        Flexible(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  removeCourseFromFavouriteAPI(item.secret ?? "");
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

  Widget titleDetail(Course item) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 16),
        child: Text(
          item.title ?? "",
          style: Singleton.instance.setTextStyle(
              textColor: Colors.white,
              fontSize: TextSize.text_18,
              fontFamily: Constant.robotoCondensedFontFamily,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> getFavouriteListAPI(bool isWantToShoProgress) async {
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    if (isWantToShoProgress) {
      Singleton.instance.showDefaultProgress();
    }

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.favouriteList);

    ApiService.getCallwithHeader(url, header, context).then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            arrFavouriteCourses.clear();
            if (json.decode(response.body)["payload"] != null) {
              json.decode(response.body)["payload"].forEach((v) {
                arrFavouriteCourses.add(Course.fromJson(v));
              });
            }

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
            getFavouriteListAPI(true);
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
