import '../../models/common/user.dart';

class LoginReposnseModel {
  bool? _success;
  String? _message;
  UserModel? _payload;
  int? _code;

  bool get success => _success!;
  String get message => _message!;
  UserModel get payload => _payload!;
  int get code => _code!;

  LoginReposnseModel(
      {bool? success, String? message, UserModel? payload, int? code}) {
    _success = success!;
    _message = message!;
    _payload = payload!;
    _code = code!;
  }

  LoginReposnseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _payload =
        json['payload'] != null ? UserModel.fromJson(json['payload']) : null;
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
