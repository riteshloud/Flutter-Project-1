// ignore_for_file: non_constant_identifier_names

import 'get_course_response_model.dart';

class FavouriteResponse {
  FavouriteResponse({
    bool? success,
    String? message,
    FavouriteListPayload? payload,
    int? code,
  }) {
    _success = success;
    _message = message;
    _payload = payload;
    _code = code;
  }

  FavouriteResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _payload = json['payload'] != null
        ? FavouriteListPayload.fromJson(json['payload'])
        : null;
    _code = json['code'];
  }
  bool? _success;
  String? _message;
  FavouriteListPayload? _payload;
  int? _code;

  bool? get success => _success;
  String? get message => _message;
  FavouriteListPayload? get payload => _payload;
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

class FavouriteListPayload {
  FavouriteListPayload({
    List<Course>? saved,
    List<Course>? in_process,
    List<Course>? completed,
    int? total_saved,
    int? total_in_process,
    int? total_completed,
  }) {
    _saved = saved;
    _in_process = in_process;
    _completed = completed;
    _total_saved = total_saved;
    _total_in_process = total_in_process;
    _total_completed = total_completed;
  }

  FavouriteListPayload.fromJson(dynamic json) {
    if (json['saved'] != null) {
      _saved = [];
      json['saved'].forEach((v) {
        _saved?.add(Course.fromJson(v));
      });
    }

    if (json['in_process'] != null) {
      _in_process = [];
      json['in_process'].forEach((v) {
        _in_process?.add(Course.fromJson(v));
      });
    }

    if (json['completed'] != null) {
      _completed = [];
      json['completed'].forEach((v) {
        _completed?.add(Course.fromJson(v));
      });
    }

    _total_saved = json['total_saved'];
    _total_in_process = json['total_in_process'];
    _total_completed = json['total_completed'];
  }

  List<Course>? _saved;
  List<Course>? _in_process;
  List<Course>? _completed;
  int? _total_saved;
  int? _total_in_process;
  int? _total_completed;

  List<Course>? get saved => _saved;
  List<Course>? get in_process => _in_process;
  List<Course>? get completed => _completed;
  int? get total_saved => _total_saved;
  int? get total_in_process => _total_in_process;
  int? get total_completed => _total_completed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_saved != null) {
      map['saved'] = _saved?.map((v) => v.toJson()).toList();
    }
    if (_in_process != null) {
      map['in_process'] = _in_process?.map((v) => v.toJson()).toList();
    }
    if (_completed != null) {
      map['completed'] = _completed?.map((v) => v.toJson()).toList();
    }

    map['total_saved'] = _total_saved;
    map['total_in_process'] = _total_in_process;
    map['total_completed'] = _total_completed;
    return map;
  }
}

/*

/// id : 3
/// title : "Socialization"
/// description : "Socialization Socialization Socialization Socialization Socialization Socialization Socialization Socialization Socialization Socialization Socialization Socialization"
/// type : "course"
/// status : 1
/// created_at : "2021-10-19T13:46:28.000000Z"
/// updated_at : "2021-10-19T13:46:28.000000Z"
/// image_full_url : "http://34.210.143.144/uploads/course_banner/616ecc340f106-1634651188.png"
/// secret : "UzVtNFB6ckFlTFQ1MWFkblpNZnlDZz09"
/// is_favorite : 0

class Workout {
  Workout(
      {int? id,
      String? title,
      String? description,
      String? type,
      int? status,
      String? createdAt,
      String? updatedAt,
      String? imageFullUrl,
      String? secret,
      int? is_favorite}) {
    _id = id;
    _title = title;
    _description = description;
    _type = type;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _imageFullUrl = imageFullUrl;
    _secret = secret;
    _is_favorite = is_favorite;
  }

  Workout.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _type = json['type'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _imageFullUrl = json['image_full_url'];
    _secret = json['secret'];
    _is_favorite = json['is_favorite'];
  }
  int? _id;
  String? _title;
  String? _description;
  String? _type;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _imageFullUrl;
  String? _secret;
  int? _is_favorite;

  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get type => _type;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get imageFullUrl => _imageFullUrl;
  String? get secret => _secret;
  int? get is_favorite => _is_favorite;

  set id(int? value) {
    _id = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['type'] = _type;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['image_full_url'] = _imageFullUrl;
    map['secret'] = _secret;
    map['is_favorite'] = _is_favorite;
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
}

/// id : 1
/// title : "Agility training"
/// description : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ac rutrum est. Cras rutrum nibh risus, vulputate aliquam dui iaculis eget. Cras dignissim in tellus at dapibus. In tempor, velit in convallis scelerisque, tellus diam tempus magna, nec ultricies lacus dui quis sapien. Donec eget orci ac massa dapibus laoreet vitae in nisl. Ut aliquet facilisis arcu, non gravida purus"
/// type : "course"
/// status : 1
/// created_at : "2021-10-19T13:45:06.000000Z"
/// updated_at : "2021-10-19T13:45:06.000000Z"
/// image_full_url : "http://34.210.143.144/uploads/course_banner/616ecbe2c600f-1634651106.png"
/// secret : "RUxsNENWcUhVTUJBbTRoemJpa0k5dz09"

class Course {
  Course({
    int? id,
    String? title,
    String? description,
    String? type,
    int? status,
    String? createdAt,
    String? updatedAt,
    String? imageFullUrl,
    String? secret,
    int? is_favorite,
  }) {
    _id = id;
    _title = title;
    _description = description;
    _type = type;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _imageFullUrl = imageFullUrl;
    _secret = secret;
    _is_favorite = is_favorite;
  }

  Course.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _type = json['type'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _imageFullUrl = json['image_full_url'];
    _secret = json['secret'];
    _is_favorite = json['is_favorite'];
  }
  int? _id;
  String? _title;
  String? _description;
  String? _type;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _imageFullUrl;
  String? _secret;
  int? _is_favorite;

  set id(int? value) {
    _id = value;
  }

  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get type => _type;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get imageFullUrl => _imageFullUrl;
  String? get secret => _secret;
  int? get is_favorite => _is_favorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['type'] = _type;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['image_full_url'] = _imageFullUrl;
    map['secret'] = _secret;
    map['is_favorite'] = _is_favorite;
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

  set isFavorite(int? value) {
    _is_favorite = value;
  }
}
*/