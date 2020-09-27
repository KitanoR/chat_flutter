
import 'package:chat_fer/models/mensaje_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'package:chat_fer/models/usuario.dart';
import 'package:chat_fer/global/environment.dart';
import 'package:chat_fer/services/auth_service.dart';

class ChatService with ChangeNotifier {
  Usuario _usuarioDestino;


  Future<List<Mensaje>> getChat(String usuarioID) async {

    try {
      final resp = await http.get('${Enviroment.apiUrl}/mensajes/$usuarioID',
       headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
    );

    final mensajesResp = mensajeResponseFromJson(resp.body);
    return mensajesResp.mensajes;
    } catch (e) {
      return [];
    }
    
  }
  // getter y setters
  Usuario get usuarioDestino  => this._usuarioDestino;

  set usuarioDestino(Usuario usuario) {
    this._usuarioDestino = usuario;
  }

}