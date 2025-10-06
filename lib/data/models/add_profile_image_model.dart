// To parse this JSON data, do
//
//     final addProfileImageModel = addProfileImageModelFromJson(jsonString);

import 'dart:convert';

AddProfileImageModel addProfileImageModelFromJson(String str) =>
    AddProfileImageModel.fromJson(json.decode(str));

String addProfileImageModelToJson(AddProfileImageModel data) =>
    json.encode(data.toJson());

class AddProfileImageModel {
  String? message;
  String? picture;

  AddProfileImageModel({this.message, this.picture});

  factory AddProfileImageModel.fromJson(Map<String, dynamic> json) =>
      AddProfileImageModel(message: json["message"], picture: json["picture"]);

  Map<String, dynamic> toJson() => {"message": message, "picture": picture};
}
