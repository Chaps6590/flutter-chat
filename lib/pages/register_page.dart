

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/Labels.dart';
import 'package:chat/widgets/btn_blue.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatelessWidget {

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
                Logo(titulo: 'Registro',),
                _Form(),
                Labels(ruta: 'login',text1: 'Ya tienes Cuenta?', text2: 'Ingresar',),
                  
                
                  
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
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>( context ); 
    final socketService = Provider.of<SocketService>( context );

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric( horizontal: 50),

      child: Column(
        children: <Widget>[

        CustomInput(
          icon: Icons.perm_identity,
          placeholder: 'Nombre',
          keyboardType: TextInputType.text,
          textController: nameCtrl,
        ),
        
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
          text: 'Crear cuenta.',
          onPressed: authServices.autenticando ? () {return null;} : () async {
              FocusScope.of(context).unfocus();
              final loginOk = await authServices.register(nameCtrl.text.trim(),emailCtrl.text.trim(), passCtrl.text.trim());
              
              if(loginOk){
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'users');
              } else {
                mostrarAlerta(context, 'Registro Incorrecto', 'Credenciales no validas.');
              }
          },
        ),


        ]),
    );
  }
}

