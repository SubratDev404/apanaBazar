
import 'dart:convert';



class CategoryModel {
    CategoryModel({
        this.response,
        this.message,
        this.data,
    });

    bool response;
    String message;
    List<Data> data;

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        response: json["response"],
        message: json["message"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Data {
    Data({
        this.id,
        this.name,
        this.image,
        this.description,
    });

    int id;
    String name;
    String image;
    String description;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
    };
}
