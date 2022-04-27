class UserProfileResponse {
  UserProfileResponse({
    bool? success,
    String? message,
    Payload? payload,
    int? code,
  }) {
    _success = success!;
    _message = message!;
    _payload = payload!;
    _code = code!;
  }

  UserProfileResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _payload =
        (json['payload'] != null ? Payload.fromJson(json['payload']) : null);
    _code = json['code'];
  }
  bool? _success;
  String? _message;
  Payload? _payload;
  int? _code;

  bool get success => _success!;
  String get message => _message!;
  Payload get payload => _payload!;
  int get code => _code!;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_payload != null) {
      map['payload'] = _payload!.toJson();
    }
    map['code'] = _code;
    return map;
  }
}

class Payload {
  Payload({
    int? id,
    String? name,
    String? email,
    String? hometown,
    String? profileImage,
    int? status,
    String? createdAt,
    String? updatedAt,
    int? firstTimeLogin,
    String? isAdmin,
    bool? getStart,
    bool? aboutDog1,
    bool? aboutDog2,
    List<K9Info>? k9Info,
  }) {
    _id = id!;
    _name = name!;
    _email = email!;
    _hometown = hometown!;
    _profileImage = profileImage!;
    _status = status!;
    _createdAt = createdAt!;
    _updatedAt = updatedAt!;
    _firstTimeLogin = firstTimeLogin!;
    _isAdmin = isAdmin!;
    _getStart = getStart!;
    _aboutDog1 = aboutDog1!;
    _aboutDog2 = aboutDog2!;
    _k9Info = k9Info!;
  }

  Payload.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _hometown = json['hometown'];
    _profileImage = json['profile_image'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _firstTimeLogin = json['first_time_login'];
    _isAdmin = json['is_admin'];
    _getStart = json['get_start'];
    _aboutDog1 = json['about_dog_1'];
    _aboutDog2 = json['about_dog_2'];
    if (json['k9_info'] != null) {
      _k9Info = [];
      json['k9_info'].forEach((v) {
        _k9Info!.add(K9Info.fromJson(v));
      });
    }
  }
  int? _id;
  String? _name;
  String? _email;
  String? _hometown;
  String? _profileImage;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _firstTimeLogin;
  String? _isAdmin;
  bool? _getStart;
  bool? _aboutDog1;
  bool? _aboutDog2;
  List<K9Info>? _k9Info;

  int get id => _id!;
  String get name => _name!;
  String get email => _email!;
  String get hometown => _hometown!;
  String get profileImage => _profileImage!;
  int get status => _status!;
  String get createdAt => _createdAt!;
  String get updatedAt => _updatedAt!;
  int get firstTimeLogin => _firstTimeLogin!;
  String get isAdmin => _isAdmin!;
  bool get getStart => _getStart!;
  bool get aboutDog1 => _aboutDog1!;
  bool get aboutDog2 => _aboutDog2!;
  List<K9Info> get k9Info => _k9Info!;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['hometown'] = _hometown;
    map['profile_image'] = _profileImage;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['first_time_login'] = _firstTimeLogin;
    map['is_admin'] = _isAdmin;
    map['get_start'] = _getStart;
    map['about_dog_1'] = _aboutDog1;
    map['about_dog_2'] = _aboutDog2;
    if (_k9Info != null) {
      map['k9_info'] = _k9Info!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class K9Info {
  K9Info({
    int? id,
    int? userId,
    String? name,
    String? breed,
    int? category,
    String? createdAt,
    String? updatedAt,
    int? status,
    int? activeStep,
  }) {
    _id = id!;
    _userId = userId!;
    _name = name!;
    _breed = breed!;
    _category = category!;
    _createdAt = createdAt!;
    _updatedAt = updatedAt!;
    _status = status!;
    _activeStep = activeStep!;
  }

  K9Info.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _name = json['name'];
    _breed = json['breed'];
    _category = json['category'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _status = json['status'];
    _activeStep = json['active_step'];
  }
  int? _id;
  int? _userId;
  String? _name;
  String? _breed;
  int? _category;
  String? _createdAt;
  String? _updatedAt;
  int? _status;
  int? _activeStep;

  int get id => _id!;
  int get userId => _userId!;
  String get name => _name!;
  String get breed => _breed!;
  int get category => _category!;
  String get createdAt => _createdAt!;
  String get updatedAt => _updatedAt!;
  int get status => _status!;
  int get activeStep => _activeStep!;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['name'] = _name;
    map['breed'] = _breed;
    map['category'] = _category;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['status'] = _status;
    map['active_step'] = _activeStep;
    return map;
  }
}
