import 'package:chat/global/env.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/users.dart';
import 'package:chat/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class ChatService with ChangeNotifier {

  late Users usuarioPara; 
  

  Future <List<Mensaje>> getChat ( String  usuarioID ) async {   

    final uri = Uri.parse('${ ENV.apiUrl }/mensajes/$usuarioID');
    final resp = await http.get(uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthServices.getToken()
      }
    );

    final mensajesResp = mensajesResponseFromJson(resp.body);


    return mensajesResp.mensajes;
  }

}

