// ignore_for_file: non_constant_identifier_names, unnecessary_getters_setters

class CourseDetailResponse {
  CourseDetailResponse({
    bool? success,
    String? message,
    CourseDetailPayload? payload,
    int? code,
  }) {
    _success = success;
    _message = message;
    _payload = payload;
    _code = code;
  }

  CourseDetailResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _payload = json['payload'] != null
        ? CourseDetailPayload.fromJson(json['payload'])
        : null;
    _code = json['code'];
  }
  bool? _success;
  String? _message;
  CourseDetailPayload? _payload;
  int? _code;

  bool? get success => _success;
  String? get message => _message;
  CourseDetailPayload? get payload => _payload;
  int? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_payload != null) {
      map['payload'] = _payload?.toJson();
    }
    map['code'] = _code;
    return map;
  }
}

class CourseDetailPayload {
  CourseDetailPayload({
    int? already_subscribed,
    CourseDetailInnerData? innerPayload,
    // int? id,
    // String? category,
    // String? title,
    // String? description,
    // String? type,
    // int? sort_order,
    // int? status,
    // String? image_full_url,
    // String? secret,
    // int? is_favorite,
    // List<LessionList>? lessionList,
  }) {
    _already_subscribed = already_subscribed;
    _innerPayload = innerPayload;

    // _id = id;
    // _category = category;
    // _title = title;
    // _description = description;
    // _type = type;
    // _sort_order = sort_order;
    // _status = status;
    // _image_full_url = image_full_url;
    // _secret = secret;
    // _is_favorite = is_favorite;
    // _lessionList = lessionList;
  }

  CourseDetailPayload.fromJson(dynamic json) {
    _already_subscribed = json['already_subscribed'];
    _innerPayload = json['course_detail'] != null
        ? CourseDetailInnerData.fromJson(json['course_detail'])
        : null;

    // _id = json['id'];
    // _category = json['category'];
    // _title = json['title'];
    // _description = json['description'];
    // _type = json['type'];

    // _sort_order = json['sort_order'];
    // _status = json['status'];
    // _image_full_url = json['image_full_url'];
    // _secret = json['secret'];
    // _is_favorite = json['is_favorite'];

    // if (json['lession_list'] != null) {
    //   _lessionList = [];
    //   json['lession_list'].forEach((v) {
    //     _lessionList?.add(LessionList.fromJson(v));
    //   });
    // }
  }
  int? _already_subscribed;
  CourseDetailInnerData? _innerPayload;

  // int? _id;
  // String? _category;
  // String? _title;
  // String? _description;
  // String? _type;
  // int? _sort_order;
  // int? _status;
  // String? _image_full_url;
  // String? _secret;
  // int? _is_favorite;
  // List<LessionList>? _lessionList;

  int? get alreadySubscribed => _already_subscribed;
  CourseDetailInnerData? get objInnerData => _innerPayload;

  // int? get id => _id;
  // String? get category => _category;
  // String? get title => _title;
  // String? get description => _description;
  // String? get type => _type;
  // int? get sort_order => _sort_order;
  // int? get status => _status;
  // String? get image_full_url => _image_full_url;
  // String? get secret => _secret;
  // int? get is_favorite => _is_favorite;
  // List<LessionList>? get lessionList => _lessionList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['already_subscribed'] = _already_subscribed;
    if (_innerPayload != null) {
      map['course_detail'] = _innerPayload?.toJson();
    }

    // map['id'] = _id;
    // map['category'] = _category;
    // map['title'] = _title;
    // map['description'] = _description;
    // map['type'] = _type;
    // map['sort_order'] = _sort_order;
    // map['status'] = _status;
    // map['image_full_url'] = _image_full_url;
    // map['secret'] = _secret;
    // map['is_favorite'] = _is_favorite;

    // if (_lessionList != null) {
    //   map['lession_list'] = _lessionList?.map((v) => v.toJson()).toList();
    // }

    return map;
  }
}

class CourseDetailInnerData {
  CourseDetailInnerData({
    int? id,
    String? category,
    String? title,
    String? description,
    String? type,
    int? is_free,
    int? sort_order,
    int? status,
    String? image_full_url,
    String? secret,
    int? is_favorite,
    List<LessionList>? lessionList,
  }) {
    _id = id;
    _category = category;
    _title = title;
    _description = description;
    _type = type;
    _sort_order = sort_order;
    _is_free = is_free;
    _status = status;
    _image_full_url = image_full_url;
    _secret = secret;
    _is_favorite = is_favorite;
    _lessionList = lessionList;
  }

  CourseDetailInnerData.fromJson(dynamic json) {
    _id = json['id'];
    _category = json['category'];
    _title = json['title'];
    _description = json['description'];
    _type = json['type'];

    _sort_order = json['sort_order'];
    _is_free = json['is_free'];
    _status = json['status'];
    _image_full_url = json['image_full_url'];
    _secret = json['secret'];
    _is_favorite = json['is_favorite'];

    if (json['lession_list'] != null) {
      _lessionList = [];
      json['lession_list'].forEach((v) {
        _lessionList?.add(LessionList.fromJson(v));
      });
    }
  }
  int? _id;
  String? _category;
  String? _title;
  String? _description;
  String? _type;
  int? _sort_order;
  int? _is_free;
  int? _status;
  String? _image_full_url;
  String? _secret;
  int? _is_favorite;
  List<LessionList>? _lessionList;

  int? get id => _id;
  String? get category => _category;
  String? get title => _title;
  String? get description => _description;
  String? get type => _type;
  int? get sort_order => _sort_order;
  int? get is_free => _is_free;
  int? get status => _status;
  String? get image_full_url => _image_full_url;
  String? get secret => _secret;
  int? get is_favorite => _is_favorite;
  List<LessionList>? get lessionList => _lessionList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['id'] = _id;
    map['category'] = _category;
    map['title'] = _title;
    map['description'] = _description;
    map['type'] = _type;
    map['sort_order'] = _sort_order;
    map['is_free'] = _is_free;
    map['status'] = _status;
    map['image_full_url'] = _image_full_url;
    map['secret'] = _secret;
    map['is_favorite'] = _is_favorite;

    if (_lessionList != null) {
      map['lession_list'] = _lessionList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class LessionList {
  LessionList({
    int? id,
    int? course_id,
    String? category,
    String? title,
    int? sort_order,
    int? status,
    String? description,
    String? image_full_url,
    String? video_url,
    String? secret,
    int? is_favorite,
    int? is_completed,
    String? duration,
    int? is_quiz,
    String? equipment,
    int? is_disabled,
    String? active_duration,
    int? is_quiz_complete,
    int? is_free,
  }) {
    _id = id;
    _course_id = course_id;
    _category = category;
    _title = title;
    _sort_order = sort_order;
    _status = status;
    _description = description;
    _image_full_url = image_full_url;
    _video_url = video_url;
    _secret = secret;
    _is_favorite = is_favorite;
    _is_completed = is_completed;
    _duration = duration;
    _is_quiz = is_quiz;
    _equipment = equipment;
    _is_disabled = is_disabled;
    _active_duration = active_duration;
    _is_quiz_complete = is_quiz_complete;
    _is_free = is_free;
  }

  LessionList.fromJson(dynamic json) {
    _id = json['id'];
    _course_id = json['course_id'];
    _category = json['category'];
    _title = json['title'];
    _sort_order = json['sort_order'];
    _status = json['status'];
    _description = json['description'];
    _image_full_url = json['image_full_url'];
    _video_url = json['video_url'];
    _secret = json['secret'];
    _is_favorite = json['is_favorite'];
    _is_completed = json['is_completed'];
    _duration = json['duration'];
    _is_quiz = json['is_quiz'];
    _equipment = json['equipment'];
    _is_disabled = json['is_disabled'];
    _active_duration = json['active_duration'];
    _is_quiz_complete = json['is_quiz_complete'];
    _is_free = json['is_free'];
  }
  int? _id;
  int? _course_id;
  String? _category;
  String? _title;
  int? _sort_order;
  int? _status;
  String? _description;
  String? _image_full_url;
  String? _video_url;
  String? _secret;
  int? _is_favorite;
  int? _is_completed;
  String? _duration;
  int? _is_quiz;
  String? _equipment;
  int? _is_disabled;
  String? _active_duration;
  int? _is_quiz_complete;
  int? _is_free;

  int? get id => _id;
  int? get course_id => _course_id;
  String? get category => _category;
  String? get title => _title;
  int? get sort_order => _sort_order;
  int? get status => _status;
  String? get description => _description;
  String? get image_full_url => _image_full_url;
  String? get video_url => _video_url;
  String? get secret => _secret;
  int? get is_favorite => _is_favorite;
  int? get is_completed => _is_completed;
  String? get duration => _duration;
  int? get is_quiz => _is_quiz;
  String? get equipment => _equipment;
  int? get is_disabled => _is_disabled;
  String? get active_duration => _active_duration;
  int? get is_quiz_complete => _is_quiz_complete;
  int? get is_free => _is_free;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['course_id'] = _course_id;
    map['category'] = _category;
    map['title'] = _title;
    map['sort_order'] = _sort_order;
    map['status'] = _status;
    map['description'] = _description;
    map['image_full_url'] = _image_full_url;
    map['video_url'] = _video_url;
    map['secret'] = _secret;
    map['is_favorite'] = _is_favorite;
    map['is_completed'] = _is_completed;
    map['duration'] = _duration;
    map['is_quiz'] = _is_quiz;
    map['equipment'] = _equipment;
    map['is_disabled'] = _is_disabled;
    map['active_duration'] = _active_duration;
    map['is_quiz_complete'] = _is_quiz_complete;
    map['is_free'] = _is_free;
    return map;
  }

  set id(int? value) {
    _id = value;
  }

  set course_id(int? value) {
    _course_id = value;
  }

  set category(String? value) {
    _category = value;
  }

  set title(String? value) {
    _title = value;
  }

  set sort_order(int? value) {
    _sort_order = value;
  }

  set status(int? value) {
    _status = value;
  }

  set description(String? value) {
    _description = value;
  }

  set image_full_url(String? value) {
    _image_full_url = value;
  }

  set video_url(String? value) {
    _video_url = value;
  }

  set secret(String? value) {
    _secret = value;
  }

  set isFavorite(int? value) {
    _is_favorite = value;
  }

  set isCompleted(int? value) {
    _is_completed = value;
  }

  set duration(String? value) {
    _duration = value;
  }

  set isQuiz(int? value) {
    _is_quiz = value;
  }

  set equipment(String? value) {
    _equipment = value;
  }

  set is_disabled(int? value) {
    _is_disabled = value;
  }

  set active_duration(String? value) {
    _active_duration = value;
  }

  set is_quiz_complete(int? value) {
    _is_quiz_complete = value;
  }
}
