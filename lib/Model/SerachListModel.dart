// To parse this JSON data, do
//
//     final searchListModel = searchListModelFromJson(jsonString);

import 'dart:convert';

List<SearchListModel> searchListModelFromJson(String str) => List<SearchListModel>.from(json.decode(str).map((x) => SearchListModel.fromJson(x)));

String searchListModelToJson(List<SearchListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchListModel {
    SearchListModel({
        this.id,
        this.itemname,
        this.image,
        this.variant,
    });

    String id;
    String itemname;
    String image;
    Variant variant;

    factory SearchListModel.fromJson(Map<String, dynamic> json) => SearchListModel(
        id: json["id"],
        itemname: json["itemname"],
        image: json["image"],
        variant: Variant.fromJson(json["variant"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "itemname": itemname,
        "image": image,
        "variant": variant.toJson(),
    };
}

class Variant {
    Variant({
        this.id,
        this.variantdetails,
    });

    List<String> id;
    List<Variantdetail> variantdetails;

    factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: List<String>.from(json["id"].map((x) => x)),
        variantdetails: List<Variantdetail>.from(json["variantdetails"].map((x) => Variantdetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": List<dynamic>.from(id.map((x) => x)),
        "variantdetails": List<dynamic>.from(variantdetails.map((x) => x.toJson())),
    };
}

class Variantdetail {
    Variantdetail({
        this.id,
        this.variantname,
        this.variantvalue,
    });

    String id;
    String variantname;
    String variantvalue;

    factory Variantdetail.fromJson(Map<String, dynamic> json) => Variantdetail(
        id: json["id"],
        variantname: json["variantname"],
        variantvalue: json["variantvalue"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "variantname": variantname,
        "variantvalue": variantvalue,
    };
}
