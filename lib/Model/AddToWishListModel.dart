// To parse this JSON data, do
//
//     final addToCartModel = addToCartModelFromJson(jsonString);

import 'dart:convert';

AddToWishListModel addToWishListModelFromJson(String str) => AddToWishListModel.fromJson(json.decode(str));

String addToWishListModelToJson(AddToWishListModel data) => json.encode(data.toJson());

class AddToWishListModel {
    AddToWishListModel({
        this.response,
        this.message,
        this.data,
    });

    bool response;
    String message;
    List<Data> data;

    factory AddToWishListModel.fromJson(Map<String, dynamic> json) => AddToWishListModel(
        response: json["response"],
        message: json["message"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Data {
    Data({
        this.id,
        this.userid,
        this.itemid,
        this.isnotified,
        this.createdAt,
        this.updatedBy,
        this.updatedAt,
        this.isactive,
        this.createdBy,
    });

    int id;
    String userid;
    String itemid;
    String isnotified;
    DateTime createdAt;
    dynamic updatedBy;
    DateTime updatedAt;
    String isactive;
    String createdBy;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userid: json["userid"],
        itemid: json["itemid"],
        isnotified: json["isnotified"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: DateTime.parse(json["updated_at"]),
        isactive: json["isactive"],
        createdBy: json["created_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "itemid": itemid,
        "isnotified": isnotified,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt.toIso8601String(),
        "isactive": isactive,
        "created_by": createdBy,
    };
}
