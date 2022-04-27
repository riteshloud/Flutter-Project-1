/// success : true
/// message : "Profile update successfully."
/// payload : {"id":4,"name":"abcd","email":"vrunda@gmail.com","hometown":"abcd","profile_image":"http://34.210.143.144/uploads/profile_images/616e9cffb6f37-1634639103.png","status":1,"created_at":"2021-10-19T09:53:56.000000Z","updated_at":"2021-10-19T10:25:03.000000Z","first_time_login":1,"is_admin":"0"}
/// code : 200

class GetStartedResponse {
  bool? _success;
  String? _message;
  Payload? _payload;
  int? _code;

  bool get success => _success!;
  String get message => _message!;
  Payload get payload => _payload!;
  int get code => _code!;

  GetStartedResponse({
      bool? success,
      String? message,
      Payload? payload,
      int? code}){
    _success = success;
    _message = message;
    _payload = payload;
    _code = code;
}

  GetStartedResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _payload = json['payload'] != null ? Payload.fromJson(json['payload']) : null;
    _code = json['code'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_payload != null) {
      map['payload'] = _payload!.toJson();
    }
    map['code'] = _code;
    return map;
  }

}

/// id : 4
/// name : "abcd"
/// email : "vrunda@gmail.com"
/// hometown : "abcd"
/// profile_image : "http://34.210.143.144/uploads/profile_images/616e9cffb6f37-1634639103.png"
/// status : 1
/// created_at : "2021-10-19T09:53:56.000000Z"
/// updated_at : "2021-10-19T10:25:03.000000Z"
/// first_time_login : 1
/// is_admin : "0"

class Payload {
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
      String? isAdmin}){
    _id = id;
    _name = name;
    _email = email;
    _hometown = hometown;
    _profileImage = profileImage;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _firstTimeLogin = firstTimeLogin;
    _isAdmin = isAdmin;
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
    map['is_admin'] = _isAdmin;
    return map;
  }

}