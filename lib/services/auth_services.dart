import 'dart:convert';

import 'package:chat/global/env.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AuthServices with ChangeNotifier{

  late Users users; 

  Future login( String email, String password ) async{

    final data = {
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${ENV.apiUrl}/login');

    final resp = await http.post(uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type':'application/json'
      }
    );

    print( resp.body );

    if( resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.users = loginResponse.usuario;
    }

  }


}