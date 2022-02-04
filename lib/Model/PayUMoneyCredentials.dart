// To parse this JSON data, do
//
//     final payUMoneyCredentialsModel = payUMoneyCredentialsModelFromJson(jsonString);

import 'dart:convert';

PayUMoneyCredentialsModel payUMoneyCredentialsModelFromJson(String str) => PayUMoneyCredentialsModel.fromJson(json.decode(str));

String payUMoneyCredentialsModelToJson(PayUMoneyCredentialsModel data) => json.encode(data.toJson());

class PayUMoneyCredentialsModel {
    PayUMoneyCredentialsModel({
        this.status,
        this.message,
        this.data,
        this.paymoney,
    });

    bool status;
    String message;
    PayUMoneyCredentialsModelData data;
    Paymoney paymoney;

    factory PayUMoneyCredentialsModel.fromJson(Map<String, dynamic> json) => PayUMoneyCredentialsModel(
        status: json["status"],
        message: json["message"],
        data: PayUMoneyCredentialsModelData.fromJson(json["data"]),
        paymoney: Paymoney.fromJson(json["paymoney"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
        "paymoney": paymoney.toJson(),
    };
}

class PayUMoneyCredentialsModelData {
    PayUMoneyCredentialsModelData({
        this.response,
        this.message,
        this.data,
    });

    bool response;
    String message;
    DataData data;

    factory PayUMoneyCredentialsModelData.fromJson(Map<String, dynamic> json) => PayUMoneyCredentialsModelData(
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
    int amount;
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

class Paymoney {
    Paymoney({
        this.key,
        this.txnid,
        this.amount,
        this.productinfo,
        this.firstname,
        this.email,
        this.phone,
        this.surl,
        this.furl,
        this.hash,
        this.udf1,
        this.udf2,
        this.udf3
        
    });

    String key;
    String txnid;
    int amount;
    String productinfo;
    String firstname;
    String email;
    int phone;
    String surl;
    String furl;
    String hash;
    String udf1;
    String udf2;
    String udf3;

    factory Paymoney.fromJson(Map<String, dynamic> json) => Paymoney(
        key: json["key"],
        txnid: json["txnid"],
        amount: json["amount"],
        productinfo: json["productinfo"],
        firstname: json["firstname"],
        email: json["email"],
        phone: json["phone"],
        surl: json["surl"],
        furl: json["furl"],
        hash: json["hash"],
        udf1: json["udf1"],
        udf2: json["udf2"],
        udf3: json["udf3"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "txnid": txnid,
        "amount": amount,
        "productinfo": productinfo,
        "firstname": firstname,
        "email": email,
        "phone": phone,
        "surl": surl,
        "furl": furl,
        "hash": hash,
        "udf1":udf1,
        "udf2":udf2,
        "udf3":udf3,

    };
}
