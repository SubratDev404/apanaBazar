// To parse this JSON data, do
//
//     final sliderImageModel = sliderImageModelFromJson(jsonString);

import 'dart:convert';

SliderImageModel sliderImageModelFromJson(String str) => SliderImageModel.fromJson(json.decode(str));

String sliderImageModelToJson(SliderImageModel data) => json.encode(data.toJson());

class SliderImageModel {
    SliderImageModel({
        this.status,
        this.data,
    });

    bool status;
    List<Datum> data;

    factory SliderImageModel.fromJson(Map<String, dynamic> json) => SliderImageModel(
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
        this.slidername,
        this.isactive,
        this.images,
    });

    String id;
    String slidername;
    String isactive;
    List<String> images;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        slidername: json["slidername"],
        isactive: json["isactive"],
        images: List<String>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "slidername": slidername,
        "isactive": isactive,
        "images": List<dynamic>.from(images.map((x) => x)),
    };
}
