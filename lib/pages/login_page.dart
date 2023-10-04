

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/widgets/Labels.dart';
import 'package:chat/widgets/btn_blue.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(titulo: 'Messenger',),
                _Form(),
                Labels(ruta: 'register',text1: 'No tienes una cuenta?',text2: 'Crear una Cuenta!',),
                  
                
                  
              ]),
          ),
        ),
      )
      ); 
  }
}


class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>( context );

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric( horizontal: 50),

      child: Column(
        children: <Widget>[
        
        CustomInput(
          icon: Icons.mail_outline,
          placeholder: 'Correo',
          keyboardType: TextInputType.emailAddress,
          textController: emailCtrl,
        ),

        CustomInput(
          icon: Icons.lock_outline,
          placeholder: 'Password',
          keyboardType: TextInputType.emailAddress,
          textController: passCtrl,
          isPassword: true,
        ),

        Btn_Blue(
          text: 'Ingrese',
          onPressed: authServices.autenticando ? () {return null;} : () async {
              FocusScope.of(context).unfocus();
              final loginOk = await authServices.login(emailCtrl.text.trim(), passCtrl.text.trim());
              
              if(loginOk){

                Navigator.pushReplacementNamed(context, 'users');
              } else {
                mostrarAlerta(context, 'Login Incorrecto', 'Credenciales no validas.');
              }
          },

        ),

        ]),
    );
  }
}

