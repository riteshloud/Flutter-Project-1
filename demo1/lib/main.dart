// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:provider/provider.dart';

import 'screens/initial_screen.dart';
import 'providers/community_provider_model.dart';
import 'models/common/user.dart';
import 'theme/app_theme.dart';
import 'routes/routes.dart';
import 'helpers/singleton.dart';
import 'helpers/constant.dart';

final ThemeData _noramlTheme = AppTheme.buildAppTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode
  Singleton.instance.customizationSVProgressHUD();
  Singleton.instance.hideProgress();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool(Constant.isLoggedIn) ?? false;
  if (kDebugMode) {
    print(status);
  }

  // GET DEVICE DETAILS
  if (Platform.isIOS) {
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    var version = iosInfo.systemVersion;
    var strVersion = (version.substring(0, 2));
    var osVersion = double.parse(strVersion);
    Singleton.instance.osVersion = osVersion;
  }

  UserModel userModel;
  if (status == true) {
    Singleton.instance.getUserModel().then((value) {
      if (value != null) {
        Map userMap = jsonDecode(value);
        userModel = UserModel.fromJson(userMap);
        if (userModel != null || userModel.id <= 0) {
          Singleton.instance.objLoginUser = userModel;
          Singleton.instance.AuthToken = Singleton.instance.objLoginUser.token;
          runApp(MyApp(loginStatus: status));
        } else {
          runApp(const MyApp(loginStatus: false));
        }
      }
    });
  } else {
    runApp(const MyApp(loginStatus: false));
  }
}

class MyApp extends StatelessWidget {
  final bool loginStatus;

  const MyApp({Key? key, required this.loginStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommunityProviderModel>(
            create: (_) => CommunityProviderModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Demo1",
        home: const InitialScreen(),
        theme: _noramlTheme,
        routes: Routes.getAll(),
      ),
    );
  }
}
