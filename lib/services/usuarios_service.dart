

import 'package:chat_fer/global/environment.dart';
import 'package:chat_fer/models/usuarios_response.dart';
import 'package:chat_fer/services/auth_service.dart';
import 'package:http/http.dart' as http;


import 'package:chat_fer/models/usuario.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuario() async {
    try {
      final resp = await http.get('${Enviroment.apiUrl}/usuarios',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );
      final usuarioResponse = usuariosResponseFromJson(resp.body);
      return usuarioResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}