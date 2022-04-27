// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'package:flutter/material.dart';

class CommunityProviderModel with ChangeNotifier {
  CommunityProviderModel({
    bool? success,
    String? message,
    Payload? payload,
    int? code,
  }) {
    _success = success;
    _message = message;
    _payload = payload;
    _code = code;
  }

  List<Blogs> _items = [];

  List<Blogs> get getCommunity {
    return [..._items];
  }

  CommunityProviderModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _payload =
        json['payload'] != null ? Payload.fromJson(json['payload']) : null;
    _code = json['code'];
  }

  bool? _success;
  String? _message;
  Payload? _payload;
  int? _code;

  bool? get success => _success;

  String? get message => _message;

  Payload? get payload => _payload;

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

class Payload {
  Payload({
    List<Blogs>? blogs,
    int? totalPage,
  }) {
    _blogs = blogs;
    _totalPage = totalPage;
  }

  Payload.fromJson(dynamic json) {
    if (json['blogs'] != null) {
      _blogs = [];
      json['blogs'].forEach((v) {
        _blogs?.add(Blogs.fromJson(v));
      });
    }
    _totalPage = json['total_page'];
  }

  List<Blogs>? _blogs;
  int? _totalPage;

  List<Blogs>? get blogs => _blogs;

  int? get totalPage => _totalPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_blogs != null) {
      map['blogs'] = _blogs?.map((v) => v.toJson()).toList();
    }
    map['total_page'] = _totalPage;
    return map;
  }
}

class Blogs {
  Blogs({
    int? id,
    String? description,
    int? status,
    String? image,
    String? secret,
    int? isOwn,
    User? user,
    String? created_at,
    List<Comments>? comments,
  }) {
    _id = id;
    _description = description;
    _status = status;
    _image = image;
    _secret = secret;
    _isOwn = isOwn;
    _user = user;
    _comments = comments;
    _created_at = created_at;
  }

  Blogs.fromJson(dynamic json) {
    _id = json['id'];
    _description = json['description'];
    _status = json['status'];
    _image = json['image'];
    _secret = json['secret'];
    _isOwn = json['is_own'];
    _created_at = json['created_at'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['comments'] != null) {
      _comments = [];

      json['comments'].forEach((v) {
        if (v != null) _comments?.add(Comments.fromJson(v));
      });
    }
  }

  int? _id;
  String? _description;
  int? _status;
  String? _image;
  String? _secret;
  int? _isOwn;
  User? _user;
  String? _created_at;
  List<Comments>? _comments;

  int? get id => _id;

  String? get description => _description;

  int? get status => _status;

  String? get image => _image;

  String? get secret => _secret;

  int? get isOwn => _isOwn;

  User? get user => _user;

  String? get created_at => _created_at;

  List<Comments>? get comments => _comments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['description'] = _description;
    map['status'] = _status;
    map['image'] = _image;
    map['secret'] = _secret;
    map['is_own'] = _isOwn;
    map['created_at'] = _created_at;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_comments != null) {
      map['comments'] = _comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Comments {
  Comments({
    int? id,
    int? userId,
    int? blogId,
    String? comment,
    String? createdAt,
    String? updatedAt,
    UserDetail? userDetail,
  }) {
    _id = id;
    _userId = userId;
    _blogId = blogId;
    _comment = comment;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _userDetail = userDetail;
  }

  Comments.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _blogId = json['blog_id'];
    _comment = json['comment'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _userDetail = json['user_detail'] != null
        ? UserDetail.fromJson(json['user_detail'])
        : null;
  }

  int? _id;
  int? _userId;
  int? _blogId;
  String? _comment;
  String? _createdAt;
  String? _updatedAt;
  UserDetail? _userDetail;

  int? get id => _id;

  int? get userId => _userId;

  int? get blogId => _blogId;

  String? get comment => _comment;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  UserDetail? get userDetail => _userDetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['blog_id'] = _blogId;
    map['comment'] = _comment;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_userDetail != null) {
      map['user_detail'] = _userDetail?.toJson();
    }
    return map;
  }
}

class UserDetail {
  UserDetail({
    int? id,
    String? name,
    String? profileImage,
  }) {
    _id = id;
    _name = name;
    _profileImage = profileImage;
  }

  UserDetail.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _profileImage = json['profile_image'];
  }

  int? _id;
  String? _name;
  String? _profileImage;

  int? get id => _id;

  String? get name => _name;

  String? get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['profile_image'] = _profileImage;
    return map;
  }
}

class User {
  User({
    int? id,
    String? name,
    String? profileImage,
  }) {
    _id = id;
    _name = name;
    _profileImage = profileImage;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _profileImage = json['profile_image'];
  }

  int? _id;
  String? _name;
  String? _profileImage;

  int? get id => _id;

  String? get name => _name;

  String? get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['profile_image'] = _profileImage;
    return map;
  }
}
