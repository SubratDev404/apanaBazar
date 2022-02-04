// To parse this JSON data, do
//
//     final verifyUserModel = verifyUserModelFromJson(jsonString);

import 'dart:convert';

VerifyUserModel verifyUserModelFromJson(String str) => VerifyUserModel.fromJson(json.decode(str));

String verifyUserModelToJson(VerifyUserModel data) => json.encode(data.toJson());

class VerifyUserModel {
  VerifyUserModel({
    this.message,
    this.status,
    this.userid,
  });

  String message;
  bool status;
  String userid;

  factory VerifyUserModel.fromJson(Map<String, dynamic> json) => VerifyUserModel(
    message: json["message"],
    status: json["status"],
    userid: json["userid"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "userid": userid,
  };
}
