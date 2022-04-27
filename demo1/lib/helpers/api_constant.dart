// Class for api tags

// ignore_for_file: constant_identifier_names

class ApiConstants {
  static const String BaseUrl = "https://localhost.com";
  static const String BaseUrlHost = "/api/v1/";

//auth
  static const String getCommonDetails = "";
  static const String login = "";
  static const String logout = "";
  static const String register = "";
  static const String forget_password = "";
  static const String change_password = "";

  //getstarted
  static const String get_started = "";
  static const String create_new = "";
  static const String update_k9 = "";
  static const String delete_k9 = "";

  //about dog1 & dog 2
  static const String skip_for_now = "";
  static const String add_dog_step1 = "";
  static const String add_dog_step2 = "";

  //user
  static const String get_user_profile = "";

  //courses and workout
  static const String getCourseList = "";
  static const String addFavourite = "";
  static const String removeFavourite = "";
  static const String searchCourse = "";
  static const String favouriteList = "";
  static const String courseDetail = "";

  //MY COURSES
  static const String favouriteCourseList = "";
  static const String changeCourseOrder = "";
  static const String searchFavouriteCourse = "";
  static const String removeFavouriteCourse = "";

  static const String exploreCourses = "";
  static const String submitQuiz = "";

  //LESSION
  static const String startLession = "";
  static const String completeLession = "e";
  static const String pauseLession = "";

  //Subscription
  static const String createSubscription = "";
  static const String checkSubscription = "";

  // community
  static const String getcommunityList = "s";
  static const String createPost = "";
  static const String removePost = "";
  static const String commentOnPost = "";
  static const String reportSpam = "";
}

class ApiParamters {
  static const String Authorization = "Authorization";
  static const String device_token = "device_token";
  static const String device_type_auth = "device_type";
  static const String email = "email";
  static const String password = "password";
  static const String newPassword = "new_password";
  static const String fullname = "fullname";
  static const String username = "username";
  static const String contact_no = "contact_no";
  static const String otp = "otp";
  static const String login_type = "login_type";
  static const String social_type = "social_type";
  static const String social_id = "social_id";
  static const String login_type_normal = "normal";
  static const String login_type_social = "social";
  static const String social_type_google = "google";
  static const String social_type_apple = "apple";
  static const String category_id = "category_id";
  static const String user_exercise_id = "user_exercise_id";
  static const String exercise_id = "exercise_id";
  static const String type = "type";
  static const String device_type = "deviceType";
  static const String receipt = "receipt";
  static const String user_id = "user_id";
  static const String product_id = "product_id";
  static const String sortOrder = "sortOrder";
  static const String oldPassword = "oldPassword";
  static const String name = "name";
  static const String userName = "user_name";
  static const String breed = "breed";
  static const String category = "category";
  static const String profile_image = "profile_image";
  static const String hometown = "hometown";
  static const String skip_tag = "skip_tag";
  static const String about_dog_1 = "about_dog_1";
  static const String about_dog_2 = "about_dog_2";
  static const String dog_id = "dog_id";
  static const String dog_details = "dog_details";

  static const String ios = "ios";
  static const String android = "android";

  static const String course_secret = "course_secret";
  static const String keyword = "keyword";
  static const String package_name = "package_name";
  static const String receipt_data = "receipt_data";
  static const String request_type = "request_type";
  static const String purchase_token = "purchase_token";
  static const String secret = "secret";
  static const String page = "page";
  static const String limit = "limit";
  static const String title = "title";
  static const String description = "description";
  static const String image = "image";
  static const String blog_secret = "blog_secret";
  static const String comment = "comment";
  static const String reason = "reason";
  static const String searchKeyword = "search_keyword";
  static const String is_own = "is_own";

  static const String my_course_secret = "my_course_secret";
  static const String course_type = "course_type";

  static const String user_secret = "user_secret";
  static const String quiz_data = "quiz_data";
  static const String duration = "duration";
}
