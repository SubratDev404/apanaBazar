// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

ProductListModel productListModelFromJson(String str) => ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) => json.encode(data.toJson());

class ProductListModel {
    ProductListModel({
        this.response,
        this.message,
        this.data,
    });

    bool response;
    String message;
    List<Datum> data;

    factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
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
        this.subcategoryid,
        this.subcategoryname,
        this.subcategorydescription,
        this.name,
        this.image,
        this.description,
    });

    int id;
    String subcategoryid;
    String subcategoryname;
    String subcategorydescription;
    String name;
    String image;
    String description;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        subcategoryid: json["subcategoryid"],
        subcategoryname: json["subcategoryname"],
        subcategorydescription: json["subcategorydescription"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "subcategoryid": subcategoryid,
        "subcategoryname": subcategoryname,
        "subcategorydescription": subcategorydescription,
        "name": name,
        "image": image,
        "description": description,
    };
}
