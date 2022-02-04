// To parse this JSON data, do
//
//     final myOrdersCancelModel = myOrdersCancelModelFromJson(jsonString);

import 'dart:convert';

MyOrdersCancelModel myOrdersCancelModelFromJson(String str) => MyOrdersCancelModel.fromJson(json.decode(str));

String myOrdersCancelModelToJson(MyOrdersCancelModel data) => json.encode(data.toJson());

class MyOrdersCancelModel {
    MyOrdersCancelModel({
        this.title,
        this.message,
        this.status,
    });

    String title;
    String message;
    bool status;

    factory MyOrdersCancelModel.fromJson(Map<String, dynamic> json) => MyOrdersCancelModel(
        title: json["title"],
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "status": status,
    };
}
