// To parse this JSON data, do
//
//     final forgotChangePasswordModel = forgotChangePasswordModelFromJson(jsonString);

import 'dart:convert';

ForgotChangePasswordModel forgotChangePasswordModelFromJson(String str) => ForgotChangePasswordModel.fromJson(json.decode(str));

String forgotChangePasswordModelToJson(ForgotChangePasswordModel data) => json.encode(data.toJson());

class ForgotChangePasswordModel {
    ForgotChangePasswordModel({
        this.status,
        this.message,
    });

    bool status;
    String message;

    factory ForgotChangePasswordModel.fromJson(Map<String, dynamic> json) => ForgotChangePasswordModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
