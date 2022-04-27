class UserModel {
  int? _id;
  String? _name;
  String? _email;
  String? _hometown;
  String? _profileImage;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _firstTimeLogin;
  bool? _getStart;
  bool? _aboutDog1;
  bool? _aboutDog2;
  String? _token;
  String? _planType;
  int? _lessionCount;
  int? _blogCount;
  String? _regType;
  int? _dogId;

  int get id => _id ?? 0;
  String get name => _name ?? "";
  String get email => _email ?? "";
  String get hometown => _hometown ?? "";
  String get profileImage => _profileImage ?? "";
  int get status => _status ?? 0;
  String get createdAt => _createdAt ?? "";
  String get updatedAt => _updatedAt ?? "";
  int get firstTimeLogin => _firstTimeLogin ?? 0;
  bool get getStart => _getStart ?? false;
  bool get aboutDog1 => _aboutDog1 ?? false;
  bool get aboutDog2 => _aboutDog2 ?? false;
  String get token => _token ?? "";
  String get planType => _planType ?? "";
  int get lessionCount => _lessionCount ?? 0;
  int get blogCount => _blogCount ?? 0;
  String get regType => _regType ?? "";
  int get dogId => _dogId ?? 0;

  UserModel({
    int? id,
    String? name,
    String? email,
    String? hometown,
    String? profileImage,
    int? status,
    String? createdAt,
    String? updatedAt,
    int? firstTimeLogin,
    bool? getStart,
    bool? aboutDog1,
    bool? aboutDog2,
    String? token,
    String? planType,
    int? lessionCount,
    int? blogCount,
    String? regType,
    int? dogId,
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
    _getStart = getStart!;
    _aboutDog1 = aboutDog1!;
    _aboutDog2 = aboutDog2!;
    _token = token!;
    _planType = planType!;
    _lessionCount = lessionCount!;
    _blogCount = blogCount!;
    _regType = regType!;
    _dogId = dogId;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _hometown = json['hometown'];
    _profileImage = json['profile_image'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _firstTimeLogin = json['first_time_login'];
    _getStart = json['get_start'];
    _aboutDog1 = json['about_dog_1'];
    _aboutDog2 = json['about_dog_2'];
    _token = json['token'];
    _planType = json['plan_type'];
    _lessionCount = json['lession_count'];
    _blogCount = json['blog_count'];
    _regType = json['reg_type'];
    _dogId = json['dog_id'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['hometown'] = _hometown;
    map['profile_image'] = _profileImage;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['first_time_login'] = _firstTimeLogin;
    map['get_start'] = _getStart;
    map['about_dog_1'] = _aboutDog1;
    map['about_dog_2'] = _aboutDog2;
    map['token'] = _token;
    map['plan_type'] = _planType;
    map['lession_count'] = _lessionCount;
    map['blog_count'] = _blogCount;
    map['reg_type'] = _regType;
    map['dog_id'] = _dogId;
    return map;
  }

  set id(int value) {
    _id = value;
  }

  set name(String value) {
    _name = value;
  }

  set email(String value) {
    _email = value;
  }

  set hometown(String value) {
    _hometown = value;
  }

  set profileImage(String value) {
    _profileImage = value;
  }

  set status(int value) {
    _status = value;
  }

  set createdAt(String value) {
    _createdAt = value;
  }

  set updatedAt(String value) {
    _updatedAt = value;
  }

  set firstTimeLogin(int value) {
    _firstTimeLogin = value;
  }

  set getStart(bool value) {
    _getStart = value;
  }

  set aboutDog1(bool value) {
    _aboutDog1 = value;
  }

  set aboutDog2(bool value) {
    _aboutDog2 = value;
  }

  set token(String value) {
    _token = value;
  }

  set planType(String value) {
    _planType = value;
  }

  set lessionCount(int value) {
    _lessionCount = value;
  }

  set blogCount(int value) {
    _blogCount = value;
  }

  set regType(String value) {
    _regType = value;
  }

  set dogId(int value) {
    _dogId = value;
  }
}

//****    PARSE LIST API TO MODEL OBJECT (STACKOVERFLOW REFERENCE LINK: https://bit.ly/3uqeXPJ)    ****/
class Country {
  String id;
  String name;
  String currency;

  Country(this.id, this.name, this.currency);

  factory Country.fromJson(Map<String, dynamic> parsedJson) {
    return Country(
      parsedJson['id'].toString(),
      parsedJson['name'].toString(),
      parsedJson['currency'].toString(),
    );
  }
}
