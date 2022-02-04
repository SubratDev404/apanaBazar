// To parse this JSON data, do
//
//     final onlinePaymentModel = onlinePaymentModelFromJson(jsonString);

import 'dart:convert';

OnlinePaymentModel onlinePaymentModelFromJson(String str) => OnlinePaymentModel.fromJson(json.decode(str));

String onlinePaymentModelToJson(OnlinePaymentModel data) => json.encode(data.toJson());

class OnlinePaymentModel {
  OnlinePaymentModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  OnlinePaymentModelData data;

  factory OnlinePaymentModel.fromJson(Map<String, dynamic> json) => OnlinePaymentModel(
    status: json["status"],
    message: json["message"],
    data: OnlinePaymentModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class OnlinePaymentModelData {
  OnlinePaymentModelData({
    this.response,
    this.message,
    this.data,
  });

  bool response;
  String message;
  DataData data;

  factory OnlinePaymentModelData.fromJson(Map<String, dynamic> json) => OnlinePaymentModelData(
    response: json["response"],
    message: json["message"],
    data: DataData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response,
    "message": message,
    "data": data.toJson(),
  };
}

class DataData {
  DataData({
    this.orderno,
    this.amount,
    this.transactionrefno,
    this.itemdetails,
    this.statuscode,
    this.statusdescription,
    this.partyid,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String orderno;
  double amount;
  String transactionrefno;
  String itemdetails;
  String statuscode;
  String statusdescription;
  int partyid;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    orderno: json["orderno"],
    amount: json["amount"],
    transactionrefno: json["transactionrefno"],
    itemdetails: json["itemdetails"],
    statuscode: json["statuscode"],
    statusdescription: json["statusdescription"],
    partyid: json["partyid"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "orderno": orderno,
    "amount": amount,
    "transactionrefno": transactionrefno,
    "itemdetails": itemdetails,
    "statuscode": statuscode,
    "statusdescription": statusdescription,
    "partyid": partyid,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
