// To parse this JSON data, do
//
//     final getBannerModel = getBannerModelFromJson(jsonString);

import 'dart:convert';

GetBannerModel getBannerModelFromJson(String str) =>
    GetBannerModel.fromJson(json.decode(str));

String getBannerModelToJson(GetBannerModel data) => json.encode(data.toJson());

class GetBannerModel {
  String? message;
  String? data;

  GetBannerModel({this.message, this.data});

  factory GetBannerModel.fromJson(Map<String, dynamic> json) =>
      GetBannerModel(message: json["message"], data: json["data"]);

  Map<String, dynamic> toJson() => {"message": message, "data": data};
}
