// To parse this JSON data, do
//
//     final getSubjectModel = getSubjectModelFromJson(jsonString);

import 'dart:convert';

GetSubjectModel getSubjectModelFromJson(String str) =>
    GetSubjectModel.fromJson(json.decode(str));

String getSubjectModelToJson(GetSubjectModel data) =>
    json.encode(data.toJson());

class GetSubjectModel {
  String? message;
  List<Datum>? data;

  GetSubjectModel({this.message, this.data});

  factory GetSubjectModel.fromJson(Map<String, dynamic> json) =>
      GetSubjectModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? subject;
  String? icon;
  String? mainColor;
  String? gradientColor;

  Datum({this.subject, this.icon, this.mainColor, this.gradientColor});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    subject: json["subject"],
    icon: json["icon"],
    mainColor: json["main-color"],
    gradientColor: json["gradient-color"],
  );

  Map<String, dynamic> toJson() => {
    "subject": subject,
    "icon": icon,
    "main-color": mainColor,
    "gradient-color": gradientColor,
  };
}
