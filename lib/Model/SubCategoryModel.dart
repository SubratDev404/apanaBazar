// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

SubCategoryModel subCategoryModelFromJson(String str) => SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) => json.encode(data.toJson());

class SubCategoryModel {
    SubCategoryModel({
        this.response,
        this.message,
        this.data,
    });

    bool response;
    String message;
    List<Datum> data;

    factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
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
        this.categoryid,
        this.name,
        this.image,
        this.description,
    });

    int id;
    String categoryid;
    String name;
    String image;
    String description;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryid: json["categoryid"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "categoryid": categoryid,
        "name": name,
        "image": image,
        "description": description,
    };
}


// class SubcategoryModel{
//   List data;

//   SubcategoryModel(
//     {this.data}
//   );

//   SubcategoryModel.fromJson(Map<String, dynamic> json) {
//     data = json['data'];
//   }

//   Map<String,dynamic> toJson()=>{
//      "data":data,
//   };
    

// }

// class MData{
//   String id,categoryid,name,image,description;

//   MData(
//     {this.id,this.categoryid,this.name,this.image,this.description}
//   );

//   MData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     categoryid = json['categoryid'];
//     name = json['name'];
//     image = json['image'];
//     description = json['description'];
    
    
    
//   }

//   Map<String,dynamic> toJson()=>{
//      "id":id,
//      "categoryid":categoryid,
//      "name":name,
//      "image":image,
//      "description":description,
    
    
//   };
    


//}