// To parse this JSON data, do
//
//     final fullNameAddingModel = fullNameAddingModelFromJson(jsonString);

import 'dart:convert';

FullNameAddingModel fullNameAddingModelFromJson(String str) =>
    FullNameAddingModel.fromJson(json.decode(str));

String fullNameAddingModelToJson(FullNameAddingModel data) =>
    json.encode(data.toJson());

class FullNameAddingModel {
  String? message;
  String? fullname;

  FullNameAddingModel({this.message, this.fullname});

  factory FullNameAddingModel.fromJson(Map<String, dynamic> json) =>
      FullNameAddingModel(message: json["message"], fullname: json["fullname"]);

  Map<String, dynamic> toJson() => {"message": message, "fullname": fullname};
}
