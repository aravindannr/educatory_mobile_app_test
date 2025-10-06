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
  String? error;
  int? userId;
  String? fullname;
  String? email;
  String? phone;
  String? picture;

  CreateUserModel({
    this.message,
    this.error,
    this.userId,
    this.fullname,
    this.email,
    this.phone,
    this.picture,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) =>
      CreateUserModel(
        message: json["message"],
        error: json["error"],
        userId: json["userId"],
        fullname: json["fullname"],
        email: json["email"],
        phone: json["phone"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "error": error,
    "userId": userId,
    "fullname": fullname,
    "email": email,
    "phone": phone,
    "picture": picture,
  };
}
