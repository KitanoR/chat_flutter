
import 'package:chat_fer/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:chat_fer/services/auth_service.dart';
import 'package:chat_fer/pages/login_page.dart';
import 'package:chat_fer/pages/usuarios_page.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Cargando...'),
          );
        },
      ),
   );
  }

  Future checkLoginState(BuildContext context) async {
    final authProvider = Provider.of<AuthService>(context, listen: false);
    final socketProvider = Provider.of<SocketService>(context);
    final autenticado = await authProvider.isLoggedIn();
    if(autenticado){
      socketProvider.connect();
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsuariosPage(),
          transitionDuration: Duration(milliseconds: 10)
        )
      );
    }else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionDuration: Duration(milliseconds: 10)
        )
      );
    }
  }
}