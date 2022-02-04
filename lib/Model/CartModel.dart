// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
    CartModel({
        this.response,
        this.message,
        this.data,
        this.carttotal,
        this.itemCount,
    });

    bool response;
    String message;
    List<Datum> data;
    int carttotal;
    int itemCount;

    factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        response: json["response"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        carttotal: json["carttotal"],
        itemCount: json["itemCount"],
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "carttotal": carttotal,
        "itemCount": itemCount,
    };
}

class Datum {
    Datum({
        this.cartid,
        this.ispurchased,
        this.isdeleted,
        this.isactive,
        this.noofitems,
        this.createdAt,
        this.inventoryid,
        this.itemid,
        this.userid,
        this.name,
        this.itemname,
        this.iscustome,
        this.brandid,
        this.manufacturer,
        this.mrp,
        this.image,
        this.variantdetails,
        this.saleprice,
        this.discount,
        this.remainstock,
        this.taxratevalue,
        this.vendorid,
        this.vendorname,
        this.vendoraddress,
        this.vendorcontacts,
        this.total,
    });

    String cartid;
    int ispurchased;
    int isdeleted;
    int isactive;
    int noofitems;
    DateTime createdAt;
    int inventoryid;
    int itemid;
    int userid;
    String name;
    String itemname;
    int iscustome;
    int brandid;
    String manufacturer;
    int mrp;
    String image;
    List<Variantdetail> variantdetails;
    int saleprice;
    String discount;
    int remainstock;
    int taxratevalue;
    int vendorid;
    String vendorname;
    String vendoraddress;
    int vendorcontacts;
    int total;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        cartid: json["cartid"],
        ispurchased: json["ispurchased"] as int,
        isdeleted: json["isdeleted"] as int,
        isactive: json["isactive"] as int,
        noofitems: json["noofitems"] as int,
        createdAt: DateTime.parse(json["created_at"]),
        inventoryid: json["inventoryid"] as int,
        itemid: json["itemid"] as int,
        userid: json["userid"] as int,
        name: json["name"],
        itemname: json["itemname"],
        iscustome: json["iscustome"] as int,
        brandid: json["brandid"] as int,
        manufacturer: json["manufacturer"],
        mrp: json["mrp"] as int,
        image: json["image"],
        variantdetails: List<Variantdetail>.from(json["variantdetails"].map((x) => Variantdetail.fromJson(x))),
        saleprice: json["saleprice"] as int,
        discount: json["discount"],
        remainstock: json["remainstock"] as int,
        taxratevalue: json["taxratevalue"] as int,
        vendorid: json["vendorid"] as int,
        vendorname: json["vendorname"],
        vendoraddress: json["vendoraddress"],
        vendorcontacts: json["vendorcontacts"] as int,
        total: json["total"] as int,
    );

    Map<String, dynamic> toJson() => {
        "cartid": cartid,
        "ispurchased": ispurchased,
        "isdeleted": isdeleted,
        "isactive": isactive,
        "noofitems": noofitems,
        "created_at": createdAt.toIso8601String(),
        "inventoryid": inventoryid,
        "itemid": itemid,
        "userid": userid,
        "name": name,
        "itemname": itemname,
        "iscustome": iscustome,
        "brandid": brandid,
        "manufacturer": manufacturer,
        "mrp": mrp,
        "image": image,
        "variantdetails": List<dynamic>.from(variantdetails.map((x) => x.toJson())),
        "saleprice": saleprice,
        "discount": discount,
        "remainstock": remainstock,
        "taxratevalue": taxratevalue,
        "vendorid": vendorid,
        "vendorname": vendorname,
        "vendoraddress": vendoraddress,
        "vendorcontacts": vendorcontacts,
        "total": total,
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
