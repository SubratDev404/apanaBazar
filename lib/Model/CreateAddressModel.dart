// To parse this JSON data, do
//
//     final createAddressModel = createAddressModelFromJson(jsonString);

import 'dart:convert';

CreateAddressModel createAddressModelFromJson(String str) => CreateAddressModel.fromJson(json.decode(str));

String createAddressModelToJson(CreateAddressModel data) => json.encode(data.toJson());

class CreateAddressModel {
    CreateAddressModel({
        this.response,
        this.message,
        this.data,
    });

    bool response;
    String message;
    Data data;

    factory CreateAddressModel.fromJson(Map<String, dynamic> json) => CreateAddressModel(
        response: json["response"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.fulladdress,
        this.additionalinfo,
        this.addresstype,
        this.pincode,
        this.userid,
        this.createdBy,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    String fulladdress;
    String additionalinfo;
    int addresstype;
    String pincode;
    int userid;
    int createdBy;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        fulladdress: json["fulladdress"],
        additionalinfo: json["additionalinfo"],
        addresstype: json["addresstype"],
        pincode: json["pincode"],
        userid: json["userid"],
        createdBy: json["created_by"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "fulladdress": fulladdress,
        "additionalinfo": additionalinfo,
        "addresstype": addresstype,
        "pincode": pincode,
        "userid": userid,
        "created_by": createdBy,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
