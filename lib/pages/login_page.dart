import 'package:chat_fer/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_fer/helpers/mostrar_alerta.dart';
import 'package:chat_fer/services/auth_service.dart';

import 'package:chat_fer/widgets/Labels.dart';
import 'package:chat_fer/widgets/LogoWidget.dart';
import 'package:chat_fer/widgets/boton_azul.dart';
import 'package:chat_fer/widgets/custom_input.dart';



class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                LogoWidget(titulo: 'Messenger',),
                _Form(),
                LabelsWidget(
                  ruta: 'register',
                  texto: '¿Aún no tienes cuenta?',
                  textAccion: 'Crea una ahora!',
                ),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w200
                  ),
                )
              ],
            ),
          ),
        ),
      ),
   );
  }
}



class _Form extends StatefulWidget {
  _Form({Key key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthService>(context);
    final socketProvider = Provider.of<SocketService>(context);
    return Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
         children: <Widget>[
           CustomInput(
             icon: Icons.mail_outline,
             placeholder: 'Correo',
             textInputType: TextInputType.emailAddress,
             textEditingController: emailCtrl,
           ),
           CustomInput(
             icon: Icons.lock_outline,
             placeholder: 'Contraseña',
             textEditingController: passCtrl,
             isPassword: true,
           ),
           SizedBox(height: 20,),
           BotonAzul(
            texto: 'Ingrese', 
            loader: provider.loader,
            onPressed: provider.loader ? null : () async {
              FocusScope.of(context).unfocus();
              final loginok = await provider.login(emailCtrl.text.trim(), passCtrl.text.trim());
              if(loginok){
                // navegar a otra pantalla 
                socketProvider.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else {
                mostrarAlerta(context, 'Error login', 'Las credenciales no son las adecuadas');
              }
            }
           )
         ],
       ),
    );
  }
}



