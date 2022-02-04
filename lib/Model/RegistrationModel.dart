// To parse this JSON data, do
//
//     final registrationModel = registrationModelFromJson(jsonString);

import 'dart:convert';

RegistrationModel registrationModelFromJson(String str) => RegistrationModel.fromJson(json.decode(str));

String registrationModelToJson(RegistrationModel data) => json.encode(data.toJson());

class RegistrationModel {
    RegistrationModel({
        this.user,
        this.token,
    });

    User user;
    String token;

    factory RegistrationModel.fromJson(Map<String, dynamic> json) => RegistrationModel(
        user: User.fromJson(json["user"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
    };
}

class User {
    User({
        this.name,
        this.contact,
        this.email,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    String name;
    String contact;
    String email;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        contact: json["contact"],
        email: json["email"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "contact": contact,
        "email": email,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
