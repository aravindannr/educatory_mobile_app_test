// To parse this JSON data, do
//
//     final verifyOtpModel = verifyOtpModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpModel verifyOtpModelFromJson(String str) =>
    VerifyOtpModel.fromJson(json.decode(str));

String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());

class VerifyOtpModel {
  String? message;
  String? token;
  int? userId;

  VerifyOtpModel({this.message, this.token, this.userId});

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => VerifyOtpModel(
    message: json["message"],
    token: json["token"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "userId": userId,
  };
}
