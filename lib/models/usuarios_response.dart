
// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/users.dart';

UsuariosResponse usuariosResponseFromJson(String str) => UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToJson(UsuariosResponse data) => json.encode(data.toJson());

class UsuariosResponse {
    bool ok;
    List<Users> usuarios;

    UsuariosResponse({
        required this.ok,
        required this.usuarios,
    });

    factory UsuariosResponse.fromJson(Map<String, dynamic> json) => UsuariosResponse(
        ok: json["ok"],
        usuarios: List<Users>.from(json["usuarios"].map((x) => Users.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}

