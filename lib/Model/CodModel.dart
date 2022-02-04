// To parse this JSON data, do
//
//     final codModel = codModelFromJson(jsonString);

import 'dart:convert';

CodModel codModelFromJson(String str) => CodModel.fromJson(json.decode(str));

String codModelToJson(CodModel data) => json.encode(data.toJson());

class CodModel {
    CodModel({
        this.transactiondetails,
        this.cartdetails,
        this.title,
        this.message,
        this.status,
        this.details,
        this.partyid,
        this.address,
        this.name,
        this.contact,
        this.delivery,
    });

    Transactiondetails transactiondetails;
    List<Cartdetail> cartdetails;
    String title;
    String message;
    bool status;
    Details details;
    String partyid;
    Address address;
    String name;
    String contact;
    List<Delivery> delivery;

    factory CodModel.fromJson(Map<String, dynamic> json) => CodModel(
        transactiondetails: Transactiondetails.fromJson(json["transactiondetails"]),
        cartdetails: List<Cartdetail>.from(json["cartdetails"].map((x) => Cartdetail.fromJson(x))),
        title: json["title"],
        message: json["message"],
        status: json["status"],
        details: Details.fromJson(json["details"]),
        partyid: json["partyid"],
        address: Address.fromJson(json["address"]),
        name: json["name"],
        contact: json["contact"],
        delivery: List<Delivery>.from(json["delivery"].map((x) => Delivery.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "transactiondetails": transactiondetails.toJson(),
        "cartdetails": List<dynamic>.from(cartdetails.map((x) => x.toJson())),
        "title": title,
        "message": message,
        "status": status,
        "details": details.toJson(),
        "partyid": partyid,
        "address": address.toJson(),
        "name": name,
        "contact": contact,
        "delivery": List<dynamic>.from(delivery.map((x) => x.toJson())),
    };
}

class Address {
    Address({
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
    dynamic updatedBy;
    DateTime updatedAt;
    String isactive;
    String isdefault;
    String pincode;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
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

class Cartdetail {
    Cartdetail({
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
    String ispurchased;
    String isdeleted;
    String isactive;
    String noofitems;
    DateTime createdAt;
    String inventoryid;
    String itemid;
    String userid;
    String name;
    String itemname;
    String iscustome;
    String brandid;
    String manufacturer;
    String mrp;
    String image;
    List<Variantdetail> variantdetails;
    String saleprice;
    String discount;
    String remainstock;
    String taxratevalue;
    String vendorid;
    String vendorname;
    String vendoraddress;
    String vendorcontacts;
    int total;

    factory Cartdetail.fromJson(Map<String, dynamic> json) => Cartdetail(
        cartid: json["cartid"],
        ispurchased: json["ispurchased"],
        isdeleted: json["isdeleted"],
        isactive: json["isactive"],
        noofitems: json["noofitems"],
        createdAt: DateTime.parse(json["created_at"]),
        inventoryid: json["inventoryid"],
        itemid: json["itemid"],
        userid: json["userid"],
        name: json["name"],
        itemname: json["itemname"],
        iscustome: json["iscustome"],
        brandid: json["brandid"],
        manufacturer: json["manufacturer"],
        mrp: json["mrp"],
        image: json["image"],
        variantdetails: List<Variantdetail>.from(json["variantdetails"].map((x) => Variantdetail.fromJson(x))),
        saleprice: json["saleprice"],
        discount: json["discount"],
        remainstock: json["remainstock"],
        taxratevalue: json["taxratevalue"],
        vendorid: json["vendorid"],
        vendorname: json["vendorname"],
        vendoraddress: json["vendoraddress"],
        vendorcontacts: json["vendorcontacts"],
        total: json["total"],
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

class Delivery {
    Delivery({
        this.itemid,
        this.itemname,
        this.brndname,
        this.quantity,
        this.vname,
        this.vaddress,
        this.vmobile,
        this.variantname,
        this.variantvalue,
    });

    String itemid;
    String itemname;
    String brndname;
    String quantity;
    String vname;
    String vaddress;
    String vmobile;
    String variantname;
    String variantvalue;

    factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        itemid: json["itemid"],
        itemname: json["itemname"],
        brndname: json["brndname"],
        quantity: json["quantity"],
        vname: json["vname"],
        vaddress: json["vaddress"],
        vmobile: json["vmobile"],
        variantname: json["variantname"],
        variantvalue: json["variantvalue"],
    );

    Map<String, dynamic> toJson() => {
        "itemid": itemid,
        "itemname": itemname,
        "brndname": brndname,
        "quantity": quantity,
        "vname": vname,
        "vaddress": vaddress,
        "vmobile": vmobile,
        "variantname": variantname,
        "variantvalue": variantvalue,
    };
}

class Details {
    Details({
        this.orderno,
        this.transid,
        this.amount,
        this.itemdetails,
        this.deliveryId,
    });

    String orderno;
    String transid;
    int amount;
    List<String> itemdetails;
    String deliveryId;

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        orderno: json["orderno"],
        transid: json["transid"],
        amount: json["amount"],
        itemdetails: List<String>.from(json["itemdetails"].map((x) => x)),
        deliveryId: json["deliveryId"],
    );

    Map<String, dynamic> toJson() => {
        "orderno": orderno,
        "transid": transid,
        "amount": amount,
        "itemdetails": List<dynamic>.from(itemdetails.map((x) => x)),
        "deliveryId": deliveryId,
    };
}

class Transactiondetails {
    Transactiondetails({
        this.id,
        this.itemdetails,
        this.deliveryId,
    });

    int id;
    String itemdetails;
    String deliveryId;

    factory Transactiondetails.fromJson(Map<String, dynamic> json) => Transactiondetails(
        id: json["id"],
        itemdetails: json["itemdetails"],
        deliveryId: json["deliveryId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "itemdetails": itemdetails,
        "deliveryId": deliveryId,
    };
}
