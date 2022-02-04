// To parse this JSON data, do
//
//     final collectionListModel = collectionListModelFromJson(jsonString);

import 'dart:convert';

DynamicListModel3 dynamicListModelFromJson(String str) => DynamicListModel3.fromJson(json.decode(str));

String dynamicListModelToJson(DynamicListModel3 data) => json.encode(data.toJson());

class DynamicListModel3 {
    DynamicListModel3({
        this.status,
        this.data,
    });

    bool status;
    List<Datum> data;

    factory DynamicListModel3.fromJson(Map<String, dynamic> json) => DynamicListModel3(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.trendname,
        this.items,
        this.islive,
        this.isactive,
        this.itemdetails,
    });

    String id;
    String trendname;
    Items items;
    String islive;
    String isactive;
    List<Itemdetail> itemdetails;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        trendname: json["trendname"],
        items: Items.fromJson(json["items"]),
        islive: json["islive"],
        isactive: json["isactive"],
        itemdetails: List<Itemdetail>.from(json["itemdetails"].map((x) => Itemdetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "trendname": trendname,
        "items": items.toJson(),
        "islive": islive,
        "isactive": isactive,
        "itemdetails": List<dynamic>.from(itemdetails.map((x) => x.toJson())),
    };
}

class Itemdetail {
    Itemdetail({
        this.itemid,
        this.itemname,
        this.image,
        this.varientdetails,
        this.mrp,
        this.saleprice,
    });

    String itemid;
    String itemname;
    String image;
    Varientdetails varientdetails;
    String mrp;
    String saleprice;

    factory Itemdetail.fromJson(Map<String, dynamic> json) => Itemdetail(
        itemid: json["itemid"],
        itemname: json["itemname"],
        image: json["image"],
        varientdetails: Varientdetails.fromJson(json["varientdetails"]),
        mrp: json["mrp"],
        saleprice: json["saleprice"],
    );

    Map<String, dynamic> toJson() => {
        "itemid": itemid,
        "itemname": itemname,
        "image": image,
        "varientdetails": varientdetails.toJson(),
        "mrp": mrp,
        "saleprice": saleprice,
    };
}

class Varientdetails {
    Varientdetails({
        this.id,
        this.variantdetails,
    });

    List<String> id;
    List<Variantdetail> variantdetails;

    factory Varientdetails.fromJson(Map<String, dynamic> json) => Varientdetails(
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

class Items {
    Items({
        this.items,
    });

    List<String> items;

    factory Items.fromJson(Map<String, dynamic> json) => Items(
        items: List<String>.from(json["items"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x)),
    };
}
