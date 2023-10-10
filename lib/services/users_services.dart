


import 'package:chat/models/usuarios_response.dart';
import 'package:chat/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:chat/models/users.dart';
import 'package:chat/global/env.dart';

class UsersServices {

  Future<List<Users>> getUsuarios() async {
    
    try {

      final uri = Uri.parse('${ ENV.apiUrl }/usuarios');

      final resp = await http.get(uri, 
        headers: {
          'Content-Type':'application/json',
          'x-token': await AuthServices.getToken()
        }
      );

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;


    } catch (e) {
      return [];
    }


  }


}