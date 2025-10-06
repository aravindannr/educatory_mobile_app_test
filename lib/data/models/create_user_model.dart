// To parse this JSON data, do
//
//     final createUserModel = createUserModelFromJson(jsonString);

import 'dart:convert';

CreateUserModel createUserModelFromJson(String str) =>
    CreateUserModel.fromJson(json.decode(str));

String createUserModelToJson(CreateUserModel data) =>
    json.encode(data.toJson());

class CreateUserModel {
  String? message;
  int? userId;
  String? fullname;
  String? email;
  String? phone;
  String? picture;

  CreateUserModel({
    this.message,
    this.userId,
    this.fullname,
    this.email,
    this.phone,
    this.picture,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) =>
      CreateUserModel(
        message: json["message"],
        userId: json["userId"],
        fullname: json["fullname"],
        email: json["email"],
        phone: json["phone"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "userId": userId,
    "fullname": fullname,
    "email": email,
    "phone": phone,
    "picture": picture,
  };
}
