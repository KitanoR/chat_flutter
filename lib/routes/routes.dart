import 'package:flutter/material.dart';

import 'package:chat_fer/pages/chat_page.dart';
import 'package:chat_fer/pages/loading_page.dart';
import 'package:chat_fer/pages/login_page.dart';
import 'package:chat_fer/pages/register_page.dart';
import 'package:chat_fer/pages/usuarios_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsuariosPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),

};