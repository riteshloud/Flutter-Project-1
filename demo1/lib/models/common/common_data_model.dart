import '../../models/common/dog_categories.dart';
import '../../models/common/k9_step1.dart';
import '../../models/common/k9_step2.dart';

class CommonDataModel {
  bool? _success;
  String? _message;
  Payload? _payload;
  int? _code;

  bool get success => _success!;
  String get message => _message!;
  Payload get payload => _payload!;
  int get code => _code!;

  set success(bool value) {
    _success = value;
  }

  CommonDataModel(
      {bool? success, String? message, Payload? payload, int? code}) {
    _success = success;
    _message = message;
    _payload = payload;
    _code = code;
  }

  CommonDataModel.fromJson(dynamic json) {
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

  set message(String value) {
    _message = value;
  }

  set payload(Payload value) {
    _payload = value;
  }

  set code(int value) {
    _code = value;
  }
}

class Payload {
  List<Categories>? _categories;
  List<K9Questions>? _k9Questions;
  List<K9QuestionStep2>? _k9QuestionStep2;

  List<Categories> get categories => _categories!;
  List<K9Questions> get k9Questions => _k9Questions!;
  List<K9QuestionStep2> get k9QuestionStep2 => _k9QuestionStep2!;

  set categories(List<Categories> value) {
    _categories = value;
  }

  set k9Questions(List<K9Questions> value) {
    _k9Questions = value;
  }

  set k9QuestionStep2(List<K9QuestionStep2> value) {
    _k9QuestionStep2 = value;
  }

  Payload(
      {List<Categories>? categories,
      List<K9Questions>? k9Questions,
      List<K9QuestionStep2>? k9QuestionStep2}) {
    _categories = categories;
    _k9Questions = k9Questions;
    _k9QuestionStep2 = k9QuestionStep2;
  }

  Payload.fromJson(dynamic json) {
    if (json['categories'] != null) {
      _categories = [];
      json['categories'].forEach((v) {
        _categories!.add(Categories.fromJson(v));
      });
    }
    if (json['k9_questions'] != null) {
      _k9Questions = [];
      json['k9_questions'].forEach((v) {
        _k9Questions!.add(K9Questions.fromJson(v));
      });
    }
    if (json['k9_question_step_2'] != null) {
      _k9QuestionStep2 = [];
      json['k9_question_step_2'].forEach((v) {
        _k9QuestionStep2!.add(K9QuestionStep2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_categories != null) {
      map['categories'] = _categories!.map((v) => v.toJson()).toList();
    }
    if (_k9Questions != null) {
      map['k9_questions'] = _k9Questions!.map((v) => v.toJson()).toList();
    }
    if (_k9QuestionStep2 != null) {
      map['k9_question_step_2'] =
          _k9QuestionStep2!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Option {
  String? _key;
  String? _value;
  bool? _isSelected = false;

  String get key => _key!;
  String get value => _value!;
  bool get isSelected => _isSelected!;

  set key(String value) {
    _key = value;
  }

  Option({
    String? key,
    String? value,
    bool? isSelected,
  }) {
    _key = key!;
    _value = value!;
  }

  Option.fromJson(dynamic json) {
    _key = json['key'];
    _value = json['value'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['key'] = _key;
    map['value'] = _value;
    return map;
  }

  set value(String value) {
    _value = value;
  }

  set isSelected(bool isSelected) {
    _isSelected = isSelected;
  }
}
