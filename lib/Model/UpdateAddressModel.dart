// To parse this JSON data, do
//
//     final updateAddressModel = updateAddressModelFromJson(jsonString);

import 'dart:convert';

UpdateAddressModel updateAddressModelFromJson(String str) => UpdateAddressModel.fromJson(json.decode(str));

String updateAddressModelToJson(UpdateAddressModel data) => json.encode(data.toJson());

class UpdateAddressModel {
    UpdateAddressModel({
        this.response,
        this.message,
        this.data,
    });

    bool response;
    String message;
    List<Datum> data;

    factory UpdateAddressModel.fromJson(Map<String, dynamic> json) => UpdateAddressModel(
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
        this.geocords,
        this.geoaddress,
        this.fulladdress,
        this.additionalinfo,
        this.addresstype,
        this.userid,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt,
        this.isactive,
        this.isdefault,
        this.pincode,
    });

    int id;
    dynamic geocords;
    dynamic geoaddress;
    String fulladdress;
    String additionalinfo;
    String addresstype;
    String userid;
    String createdBy;
    DateTime createdAt;
    String updatedBy;
    DateTime updatedAt;
    String isactive;
    String isdefault;
    String pincode;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        geocords: json["geocords"],
        geoaddress: json["geoaddress"],
        fulladdress: json["fulladdress"],
        additionalinfo: json["additionalinfo"],
        addresstype: json["addresstype"],
        userid: json["userid"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: DateTime.parse(json["updated_at"]),
        isactive: json["isactive"],
        isdefault: json["isdefault"],
        pincode: json["pincode"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "geocords": geocords,
        "geoaddress": geoaddress,
        "fulladdress": fulladdress,
        "additionalinfo": additionalinfo,
        "addresstype": addresstype,
        "userid": userid,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt.toIso8601String(),
        "isactive": isactive,
        "isdefault": isdefault,
        "pincode": pincode,
    };
}
