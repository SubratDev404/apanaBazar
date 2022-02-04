// class LoginModel{
//   String token,id,name,email,mobile;

//   LoginModel(
//     {this.token,this.email,this.id,this.mobile,this.name}
//   );

//   LoginModel.fromJson(Map<String,dynamic> json){
//     token=json['token'];
//     id=json['id'];
//     name=json['name'];
//     email=json['email'];
//     mobile=json['mobile'];
//   }
// }

// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.response,
        this.user,
        this.token,
    });

    bool response;
    User user;
    String token;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        response: json["response"],
        user: User.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "user": user.toJson(),
        "token": token,
    };
}

class User {
    User({
        this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.photo,
        this.createdAt,
        this.updatedAt,
        this.contact,
        this.isactive,
    });

    int id;
    String name;
    String email;
    dynamic emailVerifiedAt;
    String photo;
    DateTime createdAt;
    DateTime updatedAt;
    String contact;
    String isactive;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        photo: json["photo"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        contact: json["contact"],
        isactive: json["isactive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "photo": photo,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "contact": contact,
        "isactive": isactive,
    };
}
