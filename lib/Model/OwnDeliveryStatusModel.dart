// To parse this JSON data, do
//
//     final ownDeliveryStatusModel = ownDeliveryStatusModelFromJson(jsonString);

import 'dart:convert';

OwnDeliveryStatusModel ownDeliveryStatusModelFromJson(String str) => OwnDeliveryStatusModel.fromJson(json.decode(str));

String ownDeliveryStatusModelToJson(OwnDeliveryStatusModel data) => json.encode(data.toJson());

class OwnDeliveryStatusModel {
    OwnDeliveryStatusModel({
        this.status,
        this.message,
    });

    bool status;
    String message;

    factory OwnDeliveryStatusModel.fromJson(Map<String, dynamic> json) => OwnDeliveryStatusModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
