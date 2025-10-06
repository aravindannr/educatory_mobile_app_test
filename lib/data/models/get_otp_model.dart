// To parse this JSON data, do
//
//     final getOtpModel = getOtpModelFromJson(jsonString);

import 'dart:convert';

GetOtpModel getOtpModelFromJson(String str) =>
    GetOtpModel.fromJson(json.decode(str));

String getOtpModelToJson(GetOtpModel data) => json.encode(data.toJson());

class GetOtpModel {
  String? message;
  String? email;
  String? type;

  GetOtpModel({this.message, this.email, this.type});

  factory GetOtpModel.fromJson(Map<String, dynamic> json) => GetOtpModel(
    message: json["message"],
    email: json["email"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "email": email,
    "type": type,
  };
}
