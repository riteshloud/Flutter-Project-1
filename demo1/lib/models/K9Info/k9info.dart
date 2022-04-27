class K9infoResponseModel {
  bool? _success;
  String? _message;
  Payload? _payload;
  int? _code;

  bool get success => _success!;
  String get message => _message!;
  Payload get payload => _payload!;
  int get code => _code!;

  K9infoResponseModel(
      {bool? success, String? message, Payload? payload, int? code}) {
    _success = success;
    _message = message;
    _payload = payload;
    _code = code;
  }

  K9infoResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _payload =
        json['payload'] != null ? Payload.fromJson(json['payload']) : null;
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

class Payload {
  int? _userId;
  String? _name;
  String? _breed;
  List<DogDetails>? _dogDetails;
  String? _updatedAt;
  String? _createdAt;
  int? _id;

  int get userId => _userId!;
  String get name => _name!;
  String get breed => _breed!;
  List<DogDetails> get dogDetails => _dogDetails!;
  String get updatedAt => _updatedAt!;
  String get createdAt => _createdAt!;
  int get id => _id!;

  Payload(
      {int? userId,
      String? name,
      String? breed,
      List<DogDetails>? dogDetails,
      String? updatedAt,
      String? createdAt,
      int? id}) {
    _userId = userId!;
    _name = name!;
    _breed = breed!;
    _dogDetails = dogDetails!;
    _updatedAt = updatedAt!;
    _createdAt = createdAt!;
    _id = id!;
  }

  Payload.fromJson(dynamic json) {
    _userId = json['user_id'];
    _name = json['name'];
    _breed = json['breed'];
    if (json['dog_details'] != null) {
      _dogDetails = [];
      json['dog_details'].forEach((v) {
        _dogDetails!.add(DogDetails.fromJson(v));
      });
    }
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['name'] = _name;
    map['breed'] = _breed;
    if (_dogDetails != null) {
      map['dog_details'] = _dogDetails!.map((v) => v.toJson()).toList();
    }
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }
}

class DogDetails {
  int? _questionId;
  String? _value;

  int get questionId => _questionId!;
  String get value => _value!;

  DogDetails({int? questionId, String? value}) {
    _questionId = questionId;
    _value = value;
  }

  DogDetails.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _value = json['value'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['value'] = _value;
    return map;
  }
}
