// To parse this JSON data, do
//
//     final addToCartModel = addToCartModelFromJson(jsonString);

import 'dart:convert';

AddToCartModel addToCartModelFromJson(String str) => AddToCartModel.fromJson(json.decode(str));

String addToCartModelToJson(AddToCartModel data) => json.encode(data.toJson());

class AddToCartModel {
    AddToCartModel({
        this.response,
        this.message,
        this.data,
    });

    bool response;
    String message;
    List<Datum> data;

    factory AddToCartModel.fromJson(Map<String, dynamic> json) => AddToCartModel(
        response: json["response"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.userid,
        this.inventoryid,
        this.noofitems,
        this.ispurchased,
        this.isdeleted,
        this.entryby,
        this.createdAt,
        this.updateby,
        this.updatedAt,
        this.isactive,
    });

    int id;
    String userid;
    String inventoryid;
    String noofitems;
    String ispurchased;
    String isdeleted;
    String entryby;
    DateTime createdAt;
    String updateby;
    DateTime updatedAt;
    String isactive;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userid: json["userid"],
        inventoryid: json["inventoryid"],
        noofitems: json["noofitems"],
        ispurchased: json["ispurchased"],
        isdeleted: json["isdeleted"],
        entryby: json["entryby"],
        createdAt: DateTime.parse(json["created_at"]),
        updateby: json["updateby"],
        updatedAt: DateTime.parse(json["updated_at"]),
        isactive: json["isactive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "inventoryid": inventoryid,
        "noofitems": noofitems,
        "ispurchased": ispurchased,
        "isdeleted": isdeleted,
        "entryby": entryby,
        "created_at": createdAt.toIso8601String(),
        "updateby": updateby,
        "updated_at": updatedAt.toIso8601String(),
        "isactive": isactive,
    };
}
