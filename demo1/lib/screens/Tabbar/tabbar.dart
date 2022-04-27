// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CoursesWorkouts/course_workout_screen.dart';
import 'MyCourses/favorite_course_workout_screen.dart';
import 'Community/community_screen.dart';

import '../../helpers/api_constant.dart';
import '../../helpers/constant.dart';
import '../../helpers/singleton.dart';

import '../../service/api_service.dart';

import '../../models/common/user.dart';
import '../../models/auth/login_reposnse_model.dart';

class DynamicTabbedPage extends StatefulWidget {
  int selectedIndex;
  DynamicTabbedPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _DynamicTabbedPageState createState() => _DynamicTabbedPageState();
}

class _DynamicTabbedPageState extends State<DynamicTabbedPage> {
  //static final titles = ['One', 'Two', 'Three'];
  // final icons = (BuildContext context) => [
  //       // Image.asset(AssetIcons.tab1),
  //       // Image.asset(AssetIcons.tab2),
  //       // Image.asset(AssetIcons.tab3),
  //     ];

  late List<Widget> _children = [
    CourseWorkoutScreen(selectedTabIndex: 0),
    const FavoriteCourseWorkoutScreen(),
    CommunityScreen(true, "0"),
  ];

  int _currentIndex = 0;

  late List<BottomNavigationBarItem> Function(BuildContext) items;
  late PlatformTabController tabController;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    tabController = PlatformTabController(
      initialIndex: 0,
    );

    _children = [
      CourseWorkoutScreen(selectedTabIndex: widget.selectedIndex),
      const FavoriteCourseWorkoutScreen(),
      CommunityScreen(true, "0"),
    ];

    /*
    items = (BuildContext context) => [
          BottomNavigationBarItem(
            title: const Text(
              "First",
              style: TextStyle(fontSize: 0),
            ),
            //label: '',
            icon: Image.asset(
              AssetIcons.tab1Unselected,
              width: 25,
              height: 25,
            ),
            activeIcon: Image.asset(
              AssetIcons.tab1Selected,
              width: 25,
              height: 25,
            ),
          ),
          BottomNavigationBarItem(
            title: const Text(
              "Second",
              style: TextStyle(fontSize: 0),
            ),
            // label: '',
            icon: Image.asset(
              AssetIcons.tab2Unselected,
              width: 25,
              height: 25,
            ),
            activeIcon: Image.asset(
              AssetIcons.tab2Selected,
              width: 25,
              height: 25,
            ),
          ),
          BottomNavigationBarItem(
            title: const Text(
              "Third",
              style: TextStyle(fontSize: 0),
            ),
            // label: '',
            icon: Image.asset(
              AssetIcons.tab3Unselected,
              width: 25,
              height: 25,
            ),
            activeIcon: Image.asset(
              AssetIcons.tab3Selected,
              width: 25,
              height: 25,
            ),
          ),
        ];
        */
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _children[_currentIndex],
        bottomNavigationBar: BottomAppBar(
          elevation: 8,
          //bottom navigation bar on scaffold
          color: Colors.black,
          shape: const CircularNotchedRectangle(),
          //shape of notch
          notchMargin: 5,
          //notche margin between floating button and bottom appbar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: Row(
              //children inside bottom appbar
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    onTabTapped(0);
                  },
                  child: _currentIndex == 0
                      ? Image.asset(
                          "",
                          width: 25,
                          height: 25,
                        )
                      : Image.asset(
                          "",
                          width: 25,
                          height: 25,
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    onTabTapped(1);
                  },
                  child: _currentIndex == 1
                      ? Image.asset(
                          "",
                          width: 25,
                          height: 25,
                        )
                      : Image.asset(
                          "",
                          width: 25,
                          height: 25,
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    onTabTapped(2);
                  },
                  child: _currentIndex == 2
                      ? Image.asset(
                          "",
                          width: 25,
                          height: 25,
                        )
                      : Image.asset(
                          "",
                          width: 25,
                          height: 25,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getData() {
    Singleton.instance.isInternetConnected().then((intenet) {
      if (intenet != null && intenet) {
        calluserProfile();
      } else {
        Singleton.instance.showAlertDialogWithOkAction(
            context, Constant.appName, Constant.noInternet);
      }
    });

    Singleton.instance.getUserModel().then((value) {
      if (value != null) {
        //print("===userModel" + userModel.token);
      }
    });
  }

  Future<void> calluserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginReposnseModel loginResponseModel;
    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    Map<String, String> body;

    body = {
      ApiParamters.device_type_auth: Singleton.instance.deviceType(),
      ApiParamters.user_secret: Singleton.instance.objLoginUser.id.toString()
    };

    Singleton.instance.showDefaultProgress();
    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.get_user_profile);

    ApiService.postCallwithHeader(url, body, header, context)
        .then((response) async {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            loginResponseModel =
                LoginReposnseModel.fromJson(json.decode(response.body));
            var userData = loginResponseModel.payload;

            String userCommonData = jsonEncode(
                UserModel.fromJson(json.decode(response.body)['payload']));

            if (userData != null) {
              UserModel userModel =
                  UserModel.fromJson(json.decode(response.body)['payload']);
              Singleton.instance.objLoginUser = userModel;
              Singleton.instance.setUserModel(userCommonData);

              Singleton.instance.AuthToken =
                  Singleton.instance.objLoginUser.token;
              Singleton.instance.userProfile =
                  loginResponseModel.payload.profileImage;
              prefs.setBool(Constant.isLoggedIn, true);
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
      }
    });
  }
}
