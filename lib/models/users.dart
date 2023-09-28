// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
    bool online;
    String nombre;
    String email;
    String uid;

    Users({
        required this.online,
        required this.nombre,
        required this.email,
        required this.uid,
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        online: json["online"],
        nombre: json["nombre"],
        email: json["email"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
    };
}
