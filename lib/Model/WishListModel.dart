// To parse this JSON data, do
//
//     final wishListModel = wishListModelFromJson(jsonString);

import 'dart:convert';

WishListModel wishListModelFromJson(String str) => WishListModel.fromJson(json.decode(str));

String wishListModelToJson(WishListModel data) => json.encode(data.toJson());

class WishListModel {
    WishListModel({
        this.status,
        this.data,
    });

    bool status;
    List<Data> data;

    factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
        status: json["status"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Data {
    Data({
        this.itemid,
        this.itemimage,
        this.mrp,
        this.itemname,
        this.brandid,
        this.saleprice,
        this.invid,
        this.disc,
        this.wishid,
    });

    int itemid;
    String itemimage;
    int mrp;
    String itemname;
    int brandid;
    int saleprice;
    int invid;
    String disc;
    int wishid;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        itemid: json["itemid"],
        itemimage: json["itemimage"],
        mrp: json["mrp"],
        itemname: json["itemname"],
        brandid: json["brandid"],
        saleprice: json["saleprice"],
        invid: json["invid"],
        disc: json["disc"],
        wishid: json["wishid"],
    );

    Map<String, dynamic> toJson() => {
        "itemid": itemid,
        "itemimage": itemimage,
        "mrp": mrp,
        "itemname": itemname,
        "brandid": brandid,
        "saleprice": saleprice,
        "invid": invid,
        "disc": disc,
        "wishid": wishid,
    };
}
