// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) =>
    GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) =>
    json.encode(data.toJson());

class GetProfileModel {
  String? message;
  User? user;

  GetProfileModel({this.message, this.user});

  factory GetProfileModel.fromJson(Map<String, dynamic> json) =>
      GetProfileModel(
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "user": user?.toJson()};
}

class User {
  int? id;
  String? email;
  dynamic phone;
  String? fullname;
  String? picture;

  User({this.id, this.email, this.phone, this.fullname, this.picture});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    phone: json["phone"],
    fullname: json["fullname"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone": phone,
    "fullname": fullname,
    "picture": picture,
  };
}
