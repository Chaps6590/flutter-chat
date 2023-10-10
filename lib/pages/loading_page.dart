import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/users_page.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Espere..'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {

    final authServices = Provider.of<AuthServices>(context, listen: false);
    final socketService = Provider.of<SocketService>( context );

    final autenticado = await authServices.isLoggedIn();

    if ( autenticado){

      socketService.connect();

      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_,__,___) => UsersPage(),
          transitionDuration: Duration(microseconds: 0)
          )
        );
    } else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_,__,___) => LoginPage(),
          transitionDuration: Duration(microseconds: 0)
          )
        );
    }
  }

}