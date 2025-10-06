// To parse this JSON data, do
//
//     final getMaterialsModel = getMaterialsModelFromJson(jsonString);

import 'dart:convert';

GetMaterialsModel getMaterialsModelFromJson(String str) =>
    GetMaterialsModel.fromJson(json.decode(str));

String getMaterialsModelToJson(GetMaterialsModel data) =>
    json.encode(data.toJson());

class GetMaterialsModel {
  String? message;
  List<MaterialsDatum>? data;

  GetMaterialsModel({this.message, this.data});

  factory GetMaterialsModel.fromJson(Map<String, dynamic> json) =>
      GetMaterialsModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MaterialsDatum>.from(
                json["data"]!.map((x) => MaterialsDatum.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MaterialsDatum {
  String? title;
  String? brand;
  String? price;
  String? originalPrice;
  double? rating;
  int? reviews;
  String? tag;
  String? image;

  MaterialsDatum({
    this.title,
    this.brand,
    this.price,
    this.originalPrice,
    this.rating,
    this.reviews,
    this.tag,
    this.image,
  });

  factory MaterialsDatum.fromJson(Map<String, dynamic> json) => MaterialsDatum(
    title: json["title"],
    brand: json["brand"],
    price: json["price"],
    originalPrice: json["originalPrice"],
    rating: json["rating"]?.toDouble(),
    reviews: json["reviews"],
    tag: json["tag"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "brand": brand,
    "price": price,
    "originalPrice": originalPrice,
    "rating": rating,
    "reviews": reviews,
    "tag": tag,
    "image": image,
  };
}
