import 'package:flutter/widgets.dart';

import '../helpers/strings.dart';
import '../screens/Authentication/auth_options_screen.dart';
import '../screens/Authentication/signin_screen.dart';
import '../screens/Authentication/signup_screen.dart';
import '../screens/Profile/profile_screen.dart';
import '../screens/Tabbar/tabbar.dart';
import '../screens/initial_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getAll() {
    return {
      Strings.initialScreen: (context) => const InitialScreen(),
      Strings.tabScreen: (context) => DynamicTabbedPage(selectedIndex: 0),
      Strings.authOptionsScreen: (context) => const AuthOptionsScreen(),
      Strings.signupScreen: (context) => SignupScreen(isLoginTapped: false),
      Strings.signinScreen: (context) => SigninScreen(
            isRegisterTapped: false,
          ),
      Strings.profileScreen: (context) => ProfileScreen(
            isViewProfile: false,
            userID: "",
          ),
    };
  }
}
