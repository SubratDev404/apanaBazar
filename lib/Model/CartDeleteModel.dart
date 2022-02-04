// To parse this JSON data, do
//
//     final deleteModel = deleteModelFromJson(jsonString);

import 'dart:convert';

CartDeleteModel deleteModelFromJson(String str) => CartDeleteModel.fromJson(json.decode(str));

String deleteModelToJson(CartDeleteModel data) => json.encode(data.toJson());

class CartDeleteModel {
    CartDeleteModel({
        this.response,
        this.message,
    });

    bool response;
    String message;

    factory CartDeleteModel.fromJson(Map<String, dynamic> json) => CartDeleteModel(
        response: json["response"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
    };
}
