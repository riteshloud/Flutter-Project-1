// ignore_for_file: non_constant_identifier_names, unnecessary_getters_setters

class GetCourseResponse {
  GetCourseResponse({
    bool? success,
    String? message,
    Payload? payload,
    int? code,
  }) {
    _success = success;
    _message = message;
    _payload = payload;
    _code = code;
  }

  GetCourseResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _payload =
        json['payload'] != null ? Payload.fromJson(json['payload']) : null;
    _code = json['code'];
  }
  bool? _success;
  String? _message;
  Payload? _payload;
  int? _code;

  bool? get success => _success;
  String? get message => _message;
  Payload? get payload => _payload;
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

class Payload {
  Payload({
    List<Course>? course,
    List<Course>? workout,
    int? totalCourse,
    int? totalWorkout,
  }) {
    _course = course;
    _workout = workout;
    _totalCourse = totalCourse;
    _totalWorkout = totalWorkout;
  }

  Payload.fromJson(dynamic json) {
    if (json['course'] != null) {
      _course = [];
      json['course'].forEach((v) {
        _course?.add(Course.fromJson(v));
      });
    }
    if (json['workout'] != null) {
      _workout = [];
      json['workout'].forEach((v) {
        _workout?.add(Course.fromJson(v));
      });
    }
    _totalCourse = json['total_course'];
    _totalWorkout = json['total_workout'];
  }
  List<Course>? _course;
  List<Course>? _workout;
  int? _totalCourse;
  int? _totalWorkout;

  List<Course>? get course => _course;
  List<Course>? get workout => _workout;
  int? get totalCourse => _totalCourse;
  int? get totalWorkout => _totalWorkout;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_course != null) {
      map['course'] = _course?.map((v) => v.toJson()).toList();
    }
    if (_workout != null) {
      map['workout'] = _workout?.map((v) => v.toJson()).toList();
    }
    map['total_course'] = _totalCourse;
    map['total_workout'] = _totalWorkout;
    return map;
  }
}

// class Workout {
//   Workout({
//     int? id,
//     String? title,
//     String? description,
//     String? type,
//     int? status,
//     int? is_free,
//     String? createdAt,
//     String? updatedAt,
//     String? imageFullUrl,
//     String? secret,
//     String? completedDate,
//     int? is_favorite,
//     int? noOfVideos,
//   }) {
//     _id = id;
//     _title = title;
//     _description = description;
//     _type = type;
//     _status = status;
//     _is_free = is_free;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _imageFullUrl = imageFullUrl;
//     _secret = secret;
//     _completedDate = completedDate;
//     _is_favorite = is_favorite;
//     _noOfVideos = noOfVideos;
//   }

//   Workout.fromJson(dynamic json) {
//     _id = json['id'];
//     _title = json['title'];
//     _description = json['description'];
//     _type = json['type'];
//     _status = json['status'];
//     _is_free = json['is_free'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _imageFullUrl = json['image_full_url'];
//     _secret = json['secret'];
//     _completedDate = json['completed_at'];
//     _is_favorite = json['is_favorite'];
//     _noOfVideos = json['no_of_videos'];
//   }
//   int? _id;
//   String? _title;
//   String? _description;
//   String? _type;
//   int? _status;
//   int? _is_free;
//   String? _createdAt;
//   String? _updatedAt;
//   String? _imageFullUrl;
//   String? _secret;
//   String? _completedDate;
//   int? _is_favorite;
//   int? _noOfVideos;

//   int? get id => _id;
//   String? get title => _title;
//   String? get description => _description;
//   String? get type => _type;
//   int? get status => _status;
//   int? get is_free => _is_free;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   String? get imageFullUrl => _imageFullUrl;
//   String? get secret => _secret;
//   String? get completedDate => _completedDate;
//   int? get is_favorite => _is_favorite;
//   int? get noOfVideos => _noOfVideos;

//   set id(int? value) {
//     _id = value;
//   }

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['title'] = _title;
//     map['description'] = _description;
//     map['type'] = _type;
//     map['status'] = _status;
//     map['is_free'] = _is_free;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     map['image_full_url'] = _imageFullUrl;
//     map['secret'] = _secret;
//     map['completed_at'] = _completedDate;
//     map['is_favorite'] = _is_favorite;
//     map['no_of_vidoes'] = _noOfVideos;
//     return map;
//   }

//   set title(String? value) {
//     _title = value;
//   }

//   set description(String? value) {
//     _description = value;
//   }

//   set type(String? value) {
//     _type = value;
//   }

//   set status(int? value) {
//     _status = value;
//   }

//   set is_free(int? value) {
//     _is_free = value;
//   }

//   set createdAt(String? value) {
//     _createdAt = value;
//   }

//   set updatedAt(String? value) {
//     _updatedAt = value;
//   }

//   set imageFullUrl(String? value) {
//     _imageFullUrl = value;
//   }

//   set secret(String? value) {
//     _secret = value;
//   }

//   set completedDate(String? value) {
//     _completedDate = value;
//   }

//   set noOfVideos(int? value) {
//     _noOfVideos = value;
//   }
// }

class Course {
  Course({
    int? id,
    String? title,
    String? description,
    String? type,
    int? status,
    int? is_free,
    String? createdAt,
    String? updatedAt,
    String? imageFullUrl,
    String? secret,
    String? myCourseSecret,
    int? is_favorite,
    int? noOfVideos,
    int? videoProgress,
    String? completedAt,
    int? is_free_course,
  }) {
    _id = id;
    _title = title;
    _description = description;
    _type = type;
    _status = status;
    _is_free = is_free;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _imageFullUrl = imageFullUrl;
    _secret = secret;
    _myCourseSecret = myCourseSecret;
    _is_favorite = is_favorite;
    _noOfVideos = noOfVideos;
    _videoProgress = videoProgress;
    _completedAt = completedAt;
    _is_free_course = is_free_course;
  }

  Course.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _type = json['type'];
    _status = json['status'];
    _is_free = json['is_free'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _imageFullUrl = json['image_full_url'];
    _secret = json['secret'];
    _myCourseSecret = json['my_course_secret'];
    _is_favorite = json['is_favorite'];
    _noOfVideos = json['total_video'];
    _videoProgress = json['active_video'];
    _completedAt = json['completed_date'];
    _is_free_course = json['is_free_course'];
  }
  int? _id;
  String? _title;
  String? _description;
  String? _type;
  int? _status;
  int? _is_free;
  String? _createdAt;
  String? _updatedAt;
  String? _imageFullUrl;
  String? _secret;
  String? _myCourseSecret;
  int? _is_favorite;
  int? _noOfVideos;
  int? _videoProgress;
  String? _completedAt;
  int? _is_free_course;

  set id(int? value) {
    _id = value;
  }

  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get type => _type;
  int? get status => _status;
  int? get is_free => _is_free;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get imageFullUrl => _imageFullUrl;
  String? get secret => _secret;
  String? get myCourseSecret => _myCourseSecret;
  int? get is_favorite => _is_favorite;
  int? get noOfVideos => _noOfVideos;
  int? get videoProgress => _videoProgress;
  String? get completedAt => _completedAt;
  int? get is_free_course => _is_free_course;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['type'] = _type;
    map['status'] = _status;
    map['is_free'] = _is_free;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['image_full_url'] = _imageFullUrl;
    map['secret'] = _secret;
    map['my_course_secret'] = _myCourseSecret;
    map['is_favorite'] = _is_favorite;
    map['total_video'] = _noOfVideos;
    map['active_video'] = _videoProgress;
    map['completed_date'] = _completedAt;
    map['is_free_course'] = _is_free_course;
    return map;
  }

  set title(String? value) {
    _title = value;
  }

  set description(String? value) {
    _description = value;
  }

  set type(String? value) {
    _type = value;
  }

  set status(int? value) {
    _status = value;
  }

  set is_free(int? value) {
    _is_free = value;
  }

  set createdAt(String? value) {
    _createdAt = value;
  }

  set updatedAt(String? value) {
    _updatedAt = value;
  }

  set imageFullUrl(String? value) {
    _imageFullUrl = value;
  }

  set secret(String? value) {
    _secret = value;
  }

  set myCourseSecret(String? value) {
    _myCourseSecret = value;
  }

  set isFavorite(int? value) {
    _is_favorite = value;
  }

  set noOfVideos(int? value) {
    _noOfVideos = value;
  }

  set videoProgress(int? value) {
    _videoProgress = value;
  }

  set completedAt(String? value) {
    _completedAt = value;
  }
}
