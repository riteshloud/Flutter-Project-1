import '../../models/common/common_data_model.dart';

class K9Questions {
  int? _id;
  String? _title;
  String? _description;
  List<Option>? _option;
  int? _step;
  String? _type;
  String? _createdAt;
  String? _updatedAt;

  int get id => _id!;
  String get title => _title!;
  String get description => _description!;
  List<Option> get option => _option!;
  int get step => _step!;
  String get type => _type!;
  String get createdAt => _createdAt!;
  String get updatedAt => _updatedAt!;

  K9Questions({
    int? id,
    String? title,
    String? description,
    List<Option>? option,
    int? step,
    String? type,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id!;
    _title = title!;
    _description = description!;
    _option = option!;
    _step = step!;
    _type = type!;
    _createdAt = createdAt!;
    _updatedAt = updatedAt!;
  }

  K9Questions.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    if (json['option'] != null) {
      _option = [];
      json['option'].forEach((v) {
        _option!.add(Option.fromJson(v));
      });
    }
    _step = json['step'];
    _type = json['type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    if (_option != null) {
      map['option'] = _option!.map((v) => v.toJson()).toList();
    }
    map['step'] = _step;
    map['type'] = _type;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

class K9EditQuestions {
  int? _questionID;
  String? _selectedValue;
  String? _value;

  int get questionID => _questionID!;
  String get selectedValue => _selectedValue!;
  String get value => _value!;

  K9EditQuestions({
    int? questionID,
    String? selectedValue,
  }) {
    _questionID = questionID!;
    _selectedValue = selectedValue!;
  }

  K9EditQuestions.fromJson(dynamic json) {
    _questionID = json['questionID'];
    _selectedValue = json['selectedValue'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['questionID'] = _questionID;
    map['selectedValue'] = _selectedValue;
    return map;
  }
}
