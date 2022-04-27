// ignore_for_file: non_constant_identifier_names, unnecessary_getters_setters

import '../../models/get_course_response_model.dart';

class RelatedCoursesResponse {
  RelatedCoursesResponse({
    bool? success,
    String? message,
    RelatedCoursesPayload? payload,
    int? code,
  }) {
    _success = success;
    _message = message;
    _payload = payload;
    _code = code;
  }

  RelatedCoursesResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _payload = json['payload'] != null
        ? RelatedCoursesPayload.fromJson(json['payload'])
        : null;
    _code = json['code'];
  }
  bool? _success;
  String? _message;
  RelatedCoursesPayload? _payload;
  int? _code;

  bool? get success => _success;
  String? get message => _message;
  RelatedCoursesPayload? get payload => _payload;
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

class RelatedCoursesPayload {
  RelatedCoursesPayload({
    List<Course>? related_courses,
    QuizPayload? payload,
  }) {
    _related_courses = related_courses;
    _payload = payload;
  }

  RelatedCoursesPayload.fromJson(dynamic json) {
    if (json['related_courses'] != null) {
      _related_courses = [];
      json['related_courses'].forEach((v) {
        _related_courses?.add(Course.fromJson(v));
      });
    }

    _payload = json['quiz'] != null ? QuizPayload.fromJson(json['quiz']) : null;
  }

  List<Course>? _related_courses;
  QuizPayload? _payload;

  List<Course>? get related_courses => _related_courses;
  QuizPayload? get objQuiz => _payload;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_related_courses != null) {
      map['related_courses'] =
          _related_courses?.map((v) => v.toJson()).toList();
    }

    if (_payload != null) {
      map['quiz'] = _payload?.toJson();
    }
    return map;
  }
}

class QuizPayload {
  QuizPayload({
    int? id,
    String? created_at,
    String? updated_at,
    String? secret,
    List<QuizObject>? arrQuestions,
  }) {
    _id = id;
    _created_at = created_at;
    _updated_at = updated_at;
    _secret = secret;
    _arrQuestions = arrQuestions;
  }

  QuizPayload.fromJson(dynamic json) {
    _id = json['id'];
    _created_at = json['created_at'];
    _updated_at = json['updated_at'];
    _secret = json['secret'];

    if (json['question'] != null) {
      _arrQuestions = [];
      json['question'].forEach((v) {
        _arrQuestions?.add(QuizObject.fromJson(v));
      });
    }
  }
  int? _id;
  String? _created_at;
  String? _updated_at;
  String? _secret;
  List<QuizObject>? _arrQuestions;

  int? get id => _id;
  String? get created_at => _created_at;
  String? get updated_at => _updated_at;
  String? get secret => _secret;
  List<QuizObject>? get arrQuestions => _arrQuestions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['id'] = _id;
    map['created_at'] = _created_at;
    map['updated_at'] = _updated_at;
    map['secret'] = _secret;

    if (_arrQuestions != null) {
      map['question'] = _arrQuestions?.map((v) => v.toJson()).toList();
    }

    return map;
  }

  set id(int? value) {
    _id = value;
  }

  set created_at(String? value) {
    _created_at = value;
  }

  set updated_at(String? value) {
    _updated_at = value;
  }

  set secret(String? value) {
    _secret = value;
  }
}

class QuizObject {
  QuizObject({
    int? id,
    String? question,
    String? type,
    List<AnswerObject>? arrAnswers,
  }) {
    _id = id;
    _question = question;
    _type = type;
    _arrAnswers = arrAnswers;
  }

  QuizObject.fromJson(dynamic json) {
    _id = json['id'];
    _question = json['question'];
    _type = json['type'];

    if (json['answer'] != null) {
      _arrAnswers = [];
      json['answer'].forEach((v) {
        _arrAnswers?.add(AnswerObject.fromJson(v));
      });
    }
  }
  int? _id;
  String? _question;
  String? _type;
  List<AnswerObject>? _arrAnswers;

  int? get id => _id;
  String? get question => _question;
  String? get type => _type;
  List<AnswerObject>? get arrAnswers => _arrAnswers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['question'] = _question;
    map['type'] = _type;

    if (_arrAnswers != null) {
      map['answer'] = _arrAnswers?.map((v) => v).toList();
    }

    return map;
  }

  set id(int? value) {
    _id = value;
  }

  set question(String? value) {
    _question = value;
  }

  set type(String? value) {
    _type = value;
  }
}

class AnswerObject {
  String? _value;
  bool? _isSelected = false;

  String get value => _value!;
  bool get isSelected => _isSelected!;

  AnswerObject({
    String? value,
    bool? isSelected,
  }) {
    _value = value!;
  }

  AnswerObject.fromJson(dynamic json) {
    _value = json['scalar'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['scalar'] = _value;
    return map;
  }

  set value(String value) {
    _value = value;
  }

  set isSelected(bool isSelected) {
    _isSelected = isSelected;
  }
}
