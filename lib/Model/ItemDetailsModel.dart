// To parse this JSON data, do
//
//     final itemDetailsModel = itemDetailsModelFromJson(jsonString);

import 'dart:convert';

ItemDetailsModel itemDetailsModelFromJson(String str) => ItemDetailsModel.fromJson(json.decode(str));

String itemDetailsModelToJson(ItemDetailsModel data) => json.encode(data.toJson());

class ItemDetailsModel {
    ItemDetailsModel({
        this.data,
    });

    Data data;

    factory ItemDetailsModel.fromJson(Map<String, dynamic> json) => ItemDetailsModel(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.id,
        this.itemid,
        this.variantid,
        this.itemname,
        this.itemcode,
        this.iscustome,
        this.brandid,
        this.brandname,
        this.taxrateid,
        this.taxratename,
        this.taxratevalue,
        this.manufacturer,
        this.manufacturerid,
        this.variantdetails,
        this.quantity,
        this.unitid,
        this.unitname,
        this.shortname,
        this.mrp,
        this.image,
        this.vendorid,
        this.vendorname,
        this.saleprice,
        this.discount,
        this.productname,
        this.productid,
        this.description,
        this.fetures,
        this.typename,
    });

    String id;
    String itemid;
    String variantid;
    String itemname;
    String itemcode;
    String iscustome;
    String brandid;
    String brandname;
    String taxrateid;
    String taxratename;
    String taxratevalue;
    String manufacturer;
    String manufacturerid;
    Variantdetails variantdetails;
    String quantity;
    String unitid;
    String unitname;
    dynamic shortname;
    String mrp;
    String image;
    String vendorid;
    String vendorname;
    String saleprice;
    String discount;
    String productname;
    String productid;
    String description;
    String fetures;
    String typename;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        itemid: json["itemid"],
        variantid: json["variantid"],
        itemname: json["itemname"],
        itemcode: json["itemcode"],
        iscustome: json["iscustome"],
        brandid: json["brandid"],
        brandname: json["brandname"],
        taxrateid: json["taxrateid"],
        taxratename: json["taxratename"],
        taxratevalue: json["taxratevalue"],
        manufacturer: json["manufacturer"],
        manufacturerid: json["manufacturerid"],
        variantdetails: Variantdetails.fromJson(json["variantdetails"]),
        quantity: json["quantity"],
        unitid: json["unitid"],
        unitname: json["unitname"],
        shortname: json["shortname"],
        mrp: json["mrp"],
        image: json["image"],
        vendorid: json["vendorid"],
        vendorname: json["vendorname"],
        saleprice: json["saleprice"],
        discount: json["discount"],
        productname: json["productname"],
        productid: json["productid"],
        description: json["description"],
        fetures: json["fetures"],
        typename: json["typename"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "itemid": itemid,
        "variantid": variantid,
        "itemname": itemname,
        "itemcode": itemcode,
        "iscustome": iscustome,
        "brandid": brandid,
        "brandname": brandname,
        "taxrateid": taxrateid,
        "taxratename": taxratename,
        "taxratevalue": taxratevalue,
        "manufacturer": manufacturer,
        "manufacturerid": manufacturerid,
        "variantdetails": variantdetails.toJson(),
        "quantity": quantity,
        "unitid": unitid,
        "unitname": unitname,
        "shortname": shortname,
        "mrp": mrp,
        "image": image,
        "vendorid": vendorid,
        "vendorname": vendorname,
        "saleprice": saleprice,
        "discount": discount,
        "productname": productname,
        "productid": productid,
        "description": description,
        "fetures": fetures,
        "typename": typename,
    };
}

class Variantdetails {
    Variantdetails({
        this.id,
        this.variantdetails,
    });

    List<String> id;
    List<Variantdetail> variantdetails;

    factory Variantdetails.fromJson(Map<String, dynamic> json) => Variantdetails(
        id: List<String>.from(json["id"].map((x) => x)),
        variantdetails: List<Variantdetail>.from(json["variantdetails"].map((x) => Variantdetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": List<dynamic>.from(id.map((x) => x)),
        "variantdetails": List<dynamic>.from(variantdetails.map((x) => x.toJson())),
    };
}

class Variantdetail {
    Variantdetail({
        this.id,
        this.variantname,
        this.variantvalue,
    });

    String id;
    String variantname;
    String variantvalue;

    factory Variantdetail.fromJson(Map<String, dynamic> json) => Variantdetail(
        id: json["id"],
        variantname: json["variantname"],
        variantvalue: json["variantvalue"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "variantname": variantname,
        "variantvalue": variantvalue,
    };
}
