import '../../models/common/common_data_model.dart';

class K9QuestionStep2 {
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

  set id(int value) {
    _id = value;
  }

  K9QuestionStep2({
    int? id,
    String? title,
    String? description,
    List<Option>? option,
    int? step,
    String? type,
    String? createdAt,
    String? updatedAt,
    bool? isSelected,
  }) {
    _id = id;
    _title = title;
    _description = description;
    _option = option;
    _step = step;
    _type = type;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  K9QuestionStep2.fromJson(dynamic json) {
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

  set title(String value) {
    _title = value;
  }

  set description(String value) {
    _description = value;
  }

  set option(List<Option> value) {
    _option = value;
  }

  set step(int value) {
    _step = value;
  }

  set type(String value) {
    _type = value;
  }

  set createdAt(String value) {
    _createdAt = value;
  }

  set updatedAt(String value) {
    _updatedAt = value;
  }
}
